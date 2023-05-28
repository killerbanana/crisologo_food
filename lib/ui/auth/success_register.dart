import 'package:flutter/material.dart';
import 'package:restaurant_app/styles/styles.dart';

class SuccessRegister extends StatelessWidget {
  const SuccessRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Successful Registration',
          style: textInter.copyWith(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              size: 80,
              color: Colors.green,
            ),
            SizedBox(height: 24),
            Text(
              'Registration Successful',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Welcome, User!',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 24),
            TextButton(
              onPressed: () {
                Navigator.popAndPushNamed(context, '/');
              },
              child: Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
