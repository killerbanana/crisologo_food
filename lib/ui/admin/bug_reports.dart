import 'package:flutter/material.dart';
import 'package:restaurant_app/styles/styles.dart';

class BugReports extends StatelessWidget {
  const BugReports({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bugs Reported',
          style: textInter.copyWith(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
    );
  }
}
