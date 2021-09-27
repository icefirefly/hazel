import 'package:flutter/material.dart';
import 'package:hazel/data/bsec_data.dart';
import 'package:hazel/utils/consts.dart';
import 'package:hazel/widgets/hazelnut_logo.dart';

class HazelnutWidget extends StatefulWidget {
  const HazelnutWidget({Key? key, required this.bsecData}) : super(key: key);

  final List<BsecData> bsecData;

  @override
  _HazelnutWidgetState createState() => _HazelnutWidgetState();
}

class _HazelnutWidgetState extends State<HazelnutWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.bsecData.isNotEmpty) {
      if (widget.bsecData[widget.bsecData.length - 1].detectedGasEstimate!
              .classId ==
          LABEL_ID_2) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 200, width: 200, child: HazelnutLogo()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.warning_amber,
                    color: Colors.red,
                    size: 40,
                  ),
                  Text(
                    "Possibly contains nuts",
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  )
                ],
              ),
            ],
          ),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.done_outline_outlined,
                color: HAZEL_GREEN,
                size: 100,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Should be safe to eat",
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  )
                ],
              ),
            ],
          ),
        );
      }
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(
            height: 10,
          ),
          Text(
            "Scanning...",
            style: TextStyle(fontSize: 20, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
