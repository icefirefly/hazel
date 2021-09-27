import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:hazel/utils/consts.dart';

class ScanResultTile extends StatelessWidget {
  const ScanResultTile({Key? key, required this.result, required this.onTap})
      : super(key: key);

  final ScanResult result;
  final VoidCallback onTap;

  Widget _buildTitle(BuildContext context) {
    if (result.device.name.length > 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                result.device.name,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 18),
              ),
              if (result.device.name
                  .toLowerCase()
                  .startsWith(APP_DEVICE_NAME_PREFIX))
                BME688Indicator(),
            ],
          ),
          Text(
            result.device.id.toString(),
            style: Theme.of(context).textTheme.caption,
          )
        ],
      );
    } else {
      return Text(result.device.id.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: _buildTitle(context),
      onTap: (result.advertisementData.connectable) ? onTap : null,
      leading: Icon(Icons.bluetooth),
      trailing: (result.advertisementData.connectable)
          ? Icon(Icons.arrow_forward_ios)
          : null,
    );
  }
}

class KnownScanResultTile extends StatelessWidget {
  const KnownScanResultTile(
      {Key? key, required this.device, required this.onTap})
      : super(key: key);

  final BluetoothDevice device;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Text(device.name),
          if (device.name.toLowerCase().startsWith(APP_DEVICE_NAME_PREFIX))
            BME688Indicator(),
        ],
      ),
      subtitle: Text(device.id.toString()),
      trailing: StreamBuilder<BluetoothDeviceState>(
        stream: device.state,
        initialData: BluetoothDeviceState.disconnected,
        builder: (c, snapshot) {
          if (snapshot.data == BluetoothDeviceState.connected) {
            return ElevatedButton(
              child: Text('OPEN'),
              onPressed: onTap,
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}

class BME688Indicator extends StatelessWidget {
  const BME688Indicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 10,
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Theme.of(context).primaryColor),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 1),
          child: Text(APP_DEVICE_NAME_PREFIX,
              style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
