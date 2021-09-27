import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:hazel/data/bsec_data.dart';
import 'package:hazel/models/hazel_bme688_model.dart';
import 'package:hazel/screens/landing_page.dart';
import 'package:hazel/utils/consts.dart';
import 'package:hazel/widgets/hazel_logo.dart';
import 'package:hazel/widgets/hazelnut_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.device}) : super(key: key);

  final BluetoothDevice device;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  void onDisconnectClick(BuildContext context, HazelBME688 bme) {
    bme.disconnectDevice().then(
          (value) => Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) {
                return LandingPage();
              },
            ),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    HazelBME688 bme688 = HazelBME688(device: widget.device);

    return StreamBuilder<BluetoothDeviceState>(
        stream: widget.device.state,
        initialData: BluetoothDeviceState.connecting,
        builder: (c, snapshot) {
          if (snapshot.data == BluetoothDeviceState.connected) {
            bme688.startConnection();
            return Scaffold(
              appBar: AppBar(
                leading: Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: HazelLogo(),
                ),
                leadingWidth: 120.0,
                actions: [
                  TextButton(
                      onPressed: () => onDisconnectClick(context, bme688),
                      child: Text(
                        "Disconnect",
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              ),
              body: ValueListenableBuilder<List<BsecData>>(
                  valueListenable: bme688.bsecNotifier,
                  builder: (context, bsecData, child) {
                    return HazelnutWidget(bsecData: bsecData);
                  }),
            );
          }
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                APP_HEADER_DISPLAY_NAME,
              ),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
