import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:hazel/screens/home_screen.dart';
import 'package:hazel/utils/consts.dart';
import 'package:hazel/widgets/hazel_logo.dart';
import 'package:hazel/widgets/scan_result_tile.dart';

class DeviceScanScreen extends StatefulWidget {
  const DeviceScanScreen({Key? key}) : super(key: key);

  @override
  _DeviceScanScreenState createState() => _DeviceScanScreenState();
}

class _DeviceScanScreenState extends State<DeviceScanScreen> {
  void _startScanning() {
    FlutterBlue.instance.startScan(timeout: Duration(seconds: 5));
  }

  void _stopScanning() {
    FlutterBlue.instance.stopScan();
  }

  @override
  void initState() {
    super.initState();
    _startScanning();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: HazelLogo(),
        ),
        leadingWidth: 120.0,
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            FlutterBlue.instance.startScan(timeout: Duration(seconds: 3)),
        child: ListView(
          children: [
            StreamBuilder<List<BluetoothDevice>>(
              stream: Stream.periodic(Duration(seconds: 1))
                  .asyncMap((_) => FlutterBlue.instance.connectedDevices),
              initialData: [],
              builder: (c, snapshot) => Column(
                children: snapshot.data!
                    .map((device) => KnownScanResultTile(
                        device: device,
                        onTap: () => openDevice(context, device)))
                    .toList(),
              ),
            ),
            StreamBuilder<List<ScanResult>>(
              stream: FlutterBlue.instance.scanResults,
              initialData: [],
              builder: (c, snapshot) {
                if (snapshot.hasData && snapshot.data!.length > 0) {
                  reOrderDevices(snapshot);
                  return Column(
                    children: snapshot.data!
                        .map((result) => ScanResultTile(
                            result: result,
                            onTap: () =>
                                connectToDevice(context, result.device)))
                        .toList(),
                  );
                } else {
                  return Center(
                    heightFactor: 15,
                    child: Text(
                      "No device found.\nStart scanning or refresh the page to try again.",
                      style: Theme.of(context).textTheme.subtitle1,
                      textAlign: TextAlign.center,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: StreamBuilder<bool>(
          stream: FlutterBlue.instance.isScanning,
          initialData: false,
          builder: (c, snapshot) {
            final state = snapshot.data ?? false;
            return FloatingActionButton(
              child: state ? Icon(Icons.cancel) : Icon(Icons.autorenew),
              onPressed: state ? _stopScanning : _startScanning,
            );
          }),
    );
  }

  void reOrderDevices(AsyncSnapshot<List<ScanResult>> snapshot) {
    var nonBMEDevices = snapshot.data!
        .where((a) =>
            (!a.device.name.toLowerCase().startsWith(APP_DEVICE_NAME_PREFIX)))
        .toList();
    snapshot.data!.retainWhere(
        (a) => a.device.name.toLowerCase().startsWith(APP_DEVICE_NAME_PREFIX));
    snapshot.data!.addAll(nonBMEDevices);
  }

  Future connectToDevice(BuildContext context, BluetoothDevice device) async {
    await device.connect().then((value) => Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) {
          return HomeScreen(device: device);
        })));
  }

  openDevice(BuildContext context, BluetoothDevice device) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
      return HomeScreen(device: device);
    }));
  }
}
