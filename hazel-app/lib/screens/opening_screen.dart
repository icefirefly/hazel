import 'package:flutter/material.dart';
import 'package:hazel/widgets/hazel_logo.dart';

class OpeningScreen extends StatelessWidget {
  const OpeningScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              child: HazelLogo(),
              height: 100,
            ),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}
