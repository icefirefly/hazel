import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hazel/utils/consts.dart';

class HazelnutLogo extends StatelessWidget {
  const HazelnutLogo({Key? key, this.color = Colors.grey}) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(ICON_HAZELNUT,
        color: color, semanticsLabel: 'Hazelnut detected');
  }
}
