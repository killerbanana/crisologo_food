import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/styles/styles.dart';
import 'package:restaurant_app/ui/auth/bloc/auth_bloc.dart';

class ProfileLayout extends StatelessWidget {
  const ProfileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 16),
            child: Text(
              'Hi, User',
              textAlign: TextAlign.center,
              style: textInter.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontSize: 24,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Container(
              width: double.infinity,
              child: CupertinoButton.filled(
                onPressed: () {
                  Navigator.pushNamed(context, '/change-password');
                },
                child: Text(
                  'Edit Profile',
                  style: textInter.copyWith(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Container(
              width: double.infinity,
              child: CupertinoButton.filled(
                onPressed: () {
                  Navigator.pushNamed(context, '/change-password');
                },
                child: Text(
                  'Change Password',
                  style: textInter.copyWith(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Container(
              width: double.infinity,
              child: CupertinoButton.filled(
                onPressed: () {
                  // Perform registration functionality here
                  BlocProvider.of<AuthBloc>(context).add(const LogOut());
                  Navigator.popAndPushNamed(context, '/');
                },
                child: Text(
                  'Log out',
                  style: textInter.copyWith(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
