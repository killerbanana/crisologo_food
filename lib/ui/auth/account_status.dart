import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/styles/styles.dart';
import 'package:restaurant_app/ui/auth/bloc/auth_bloc.dart';

class AccountStatus extends StatelessWidget {
  final String status;
  const AccountStatus({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Account Status',
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
            status == 'for approval'
                ? Icon(
                    Icons.lock_clock_rounded,
                    size: 80,
                    color: Colors.blue,
                  )
                : Icon(
                    Icons.close_rounded,
                    size: 80,
                    color: Colors.red,
                  ),
            SizedBox(height: 24),
            Text(
              'Welcome, User!',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'The status of your shop registration is ${status}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 24),
            TextButton(
              onPressed: () {
                BlocProvider.of<AuthBloc>(context).add(const LogOut());
                Navigator.popAndPushNamed(context, '/');
              },
              child: Text('Back to login'),
            ),
          ],
        ),
      ),
    );
  }
}
