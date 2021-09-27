import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:hazel/data/bsec_data.dart';
import 'package:hazel/utils/bme688_profile.dart';
import 'package:hazel/utils/consts.dart';
import 'package:hazel/utils/property_value_notifier.dart';

class HazelBME688 {
  HazelBME688({required this.device});

  final BluetoothDevice device;
  BluetoothCharacteristic? _writeCharacteristic;
  BluetoothCharacteristic? _readCharacteristic;

  bool _isNotificationEnabled = false;
  bool _isMtuRequested = false;
  int packetAccumulator = 0;
  String jsonAccumulator = "";
  bool _isDiscoverServiceCalled = false;
  bool _isListeningNotifications = false;
  bool _isListeningServices = false;
  bool _isListeningMtu = false;

  // ignore: cancel_subscriptions
  StreamSubscription<List<int>>? _notificationsListener;
  // ignore: cancel_subscriptions
  StreamSubscription<int>? _mtuListner;

  List<BsecData> _bsecData = <BsecData>[];
  List<BsecData> get bsecEstimates => _bsecData;

  PropertyValueNotifier<List<BsecData>> _bsecNotifier =
      PropertyValueNotifier(<BsecData>[]);
  PropertyValueNotifier<List<BsecData>> get bsecNotifier => _bsecNotifier;

  Future<void> _cleanupConnection() async {
    print("Disposing connection");
    jsonAccumulator = "";
    await _notificationsListener!.cancel();
    await _mtuListner!.cancel();
    _readCharacteristic = null;
    _notificationsListener = null;
    _writeCharacteristic = null;
    _mtuListner = null;
    _isNotificationEnabled = false;
    _isMtuRequested = false;
    _isDiscoverServiceCalled = false;
  }

  Future<void> startConnection() async {
    if (_mtuListner == null && !_isListeningMtu) {
      _isListeningMtu = true;
      if (Platform.isIOS) {
        sleep(Duration(milliseconds: 500));
      } //For IOS
      _mtuListner = device.mtu.listen((event) async {
        print("MTU value is $event");
        if (event >= DEFAULT_MTU && !_isDiscoverServiceCalled) {
          sleep(Duration(seconds: 1));
          print("Getting services");
          _isDiscoverServiceCalled = true;
          await device.discoverServices();
        } else if (event < DEFAULT_MTU && !_isMtuRequested) {
          try {
            if (!Platform.isIOS) {
              device.requestMtu(DEFAULT_MTU);
              _isMtuRequested = true;
            }
          } on Exception catch (e) {
            print("Could not update MTU. $e");
          }
        }
      });
    }
    if (!_isListeningServices) {
      _isListeningServices = true;
      device.services.listen((value) async {
        await _processDiscoveredServices(value);
      });
    }
  }

  Future<void> _processDiscoveredServices(
      List<BluetoothService> services) async {
    print("Receiving services discovered");
    services.forEach((service) {
      print("Processing service $service");

      if (service.uuid.toString().toUpperCase() == MAIN_SERVICE_ID) {
        service.characteristics.forEach((characteristic) async {
          if (characteristic.uuid.toString().toUpperCase() ==
              NOTIFICATION_CHARACTERISTIC_ID) {
            _readCharacteristic = characteristic;
            print("read characteristic discovered");
            // ignore: unnecessary_null_comparison
            if (_notificationsListener == null && !_isListeningNotifications) {
              _isListeningNotifications = true;
              _notificationsListener = characteristic.value.listen((event) {
                // print("Recieved data ${String.fromCharCodes(event)}");
                _onCharacteristicReceived.call(event);
              });
            }

            if (!_readCharacteristic!.isNotifying && !_isNotificationEnabled) {
              print("subscribing to notifications characteristic");
              _isNotificationEnabled = true;

              await _readCharacteristic!.setNotifyValue(true).then(
                  (value) async =>
                      await _setUnixTimeStamp()); //Subscribes to notifications
            }
          } else if (characteristic.uuid.toString().toUpperCase() ==
              WRITE_CHARACTERISTIC_ID) {
            _writeCharacteristic = characteristic;
          }
        });
      }
    });
  }

  Future _setUnixTimeStamp() async {
    // ignore: unnecessary_null_comparison
    if (_writeCharacteristic != null) {
      sleep(Duration(milliseconds: 100));
      print("Starting write command");
      await _setRtcTime();
    } else {
      print("Oops write characteristic is null");
    }
  }

  Future<void> _setRtcTime() async {
    final unixTimeStamp = (DateTime.now().toUtc().millisecondsSinceEpoch / 1000)
        .round(); //Convert milliseconds to seconds
    print("Writing time stamp $unixTimeStamp");
    final setRtcTimeCommand = "setrtctime $unixTimeStamp".codeUnits;
    Future.delayed(Duration(milliseconds: 500));
    await _writeCharacteristic!
        .write(setRtcTimeCommand, withoutResponse: false);
  }

  Future<void> _startSensor({int sensorId = DEFAULT_SENSOR_ID}) async {
    final startCommand = "start $sensorId $DEFAULT_DATA_RATE $All_OUTPUT_ID"
        .codeUnits; //subtract sensor id by 1 as the command takes sensor IDs starting from 0
    print("Sending Start command $startCommand");
    await Future.delayed(Duration(milliseconds: 100));
    await _writeCharacteristic!
        .write(startCommand, withoutResponse: false)
        .then((value) => {print("Write command result is success")});
  }

  Future<void> disconnectDevice() async {
    _readCharacteristic!.setNotifyValue(false);
    print("trying disconnect");
    await device.state.first.then((value) async => {
          if (value != BluetoothDeviceState.disconnected)
            {
              print("Calling disconnect"),
              await _stopSensor(),
            }
          else
            {
              print("Calling cleanup"),
              await _cleanupConnection(),
            }
        });
  }

  Future _stopSensor() async {
    final stopCommand = "stop".codeUnits;
    print("Sending Stop command $stopCommand");
    try {
      await _writeCharacteristic!.write(stopCommand);
    } on Exception catch (e) {
      print("Error writing characteristic. Disconnecting anyway.: $e");
      await _cleanupConnection();
      await device.disconnect();
    }
  }

  Future<void> _onCharacteristicReceived(List<int> data) async {
    // print("Processing data");
    if (data.isNotEmpty) {
      var jsonData = String.fromCharCodes(data);
      Map<String, dynamic>? decodedData;

      try {
        if (jsonAccumulator == jsonData) {
          print("Parsing equal accumulator $decodedData");
          return null;
        }
        // print("Parsing $jsonData");
        decodedData = json.decode(jsonAccumulator + jsonData);
        jsonAccumulator = "";
      } on FormatException catch (e) {
        print(e);
        try {
          if (jsonAccumulator == jsonData) {
            print("Parsing equal accumulator $jsonData");
            return null;
          }
          print("Parsing accumulator $jsonData");
          decodedData =
              json.decode(jsonAccumulator = jsonAccumulator + jsonData);
          jsonAccumulator = "";
        } on FormatException catch (e) {
          print("Parsed accumulator: $e");
          return null;
        }
      }

      switch (decodedData!.keys.first) {
        case TAG_BME68X: //Handle bme data = current measurement
          break;
        case TAG_BSEC: //Handle bsec data = classification
          print("received bsec log");
          final gasResult = BsecData.fromJson(decodedData);
          _addDetectedGasResult(gasResult);
          break;
        case "setrtctime":
          if (decodedData.values.first.toString() == "0") {
            print("rtc time set.");
            _startSensor();
          } else {
            print(
                "Error setting rtc time. response: ${String.fromCharCodes(data)}");
          }
          break;
        case "getrtctime":
          break;
        case "start":
          final response = decodedData.values.first;
          if (response.toString() != "0") {
            print("Start error");
            print(
                "Could not start sensor. response code: ${ErrorCodes.values[response].toString().split('.')[1]}");
          }
          break;
        case "stop":
          print("Stop was successful. Disconnecting..");
          await _cleanupConnection();
          await device.disconnect();
          break;
      }
    }
  }

  void _addDetectedGasResult(BsecData gasResult) {
    if (_bsecData.length >= Max_Gas_Estimates_To_Remember) {
      _bsecData.removeAt(0);
    }
    print("Class: " +
        gasResult.detectedGasEstimate!.classId.toString() +
        " Prob: " +
        gasResult.detectedGasEstimate!.probability.toString());
    _bsecData.add(gasResult);
    _bsecNotifier.value = [];
    _bsecNotifier.value = _bsecData;
    _bsecNotifier.notifyListeners();
  }
}
