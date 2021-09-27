import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hazel/utils/consts.dart';

class HazelLogo extends StatelessWidget {
  const HazelLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(ICON_HAZEL,
        color: Colors.white, semanticsLabel: 'Hazel Logo');
  }
}
