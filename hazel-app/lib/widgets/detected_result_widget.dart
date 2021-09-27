import 'package:hazel/data/bsec_data.dart';
import 'package:flutter/material.dart';
import 'package:hazel/utils/consts.dart';

class DetectedGasResultWidget extends StatelessWidget {
  const DetectedGasResultWidget({Key? key, required this.bsecData})
      : super(key: key);

  final List<BsecData> bsecData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: (bsecData.isNotEmpty
                  ? bsecData[bsecData.length - 1].allGasEstimates
                  : NO_CLASSIFICATION)
              .map((estimate) => DetectedGasResultTile(estimate: estimate))
              .toList()),
    );
  }
}

class DetectedGasResultTile extends StatelessWidget {
  const DetectedGasResultTile({Key? key, required this.estimate})
      : super(key: key);

  final GasEstimate estimate;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: DEFAULT_COLOR[estimate.classId - 1].withOpacity(0.2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          FractionallySizedBox(
            widthFactor: estimate.probability / 100,
            child: Container(
              height: 10,
              color: DEFAULT_COLOR[estimate.classId - 1],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Column(children: [
              Text(DEFAULT_LABEL_NAME[estimate.classId - 1]),
              Text(estimate.probability.round().toString() + "%")
            ]),
          ),
        ],
      ),
      height: 80,
    );
  }
}
