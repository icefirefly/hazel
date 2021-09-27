import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:hazel/widgets/hazel_logo.dart';

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key? key, required this.state}) : super(key: key);

  final BluetoothState state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: HazelLogo(),
            ),
            Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
              color: Colors.grey,
            ),
            Text(
              'Pls activate Bluetooth',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}
