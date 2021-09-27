import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:hazel/screens/bluetooth_off_screen.dart';
import 'package:hazel/screens/device_scan_screen.dart';
import 'package:hazel/screens/opening_screen.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BluetoothState>(
        stream: FlutterBlue.instance.state,
        initialData: BluetoothState.unknown,
        builder: (c, snapshot) {
          final state = snapshot.data;
          switch (state) {
            case BluetoothState.on:
              return DeviceScanScreen();
            case BluetoothState.unknown:
              return OpeningScreen();
            default:
              return BluetoothOffScreen(state: state ?? BluetoothState.unknown);
          }
        });
  }
}
