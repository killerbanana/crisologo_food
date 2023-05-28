import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/styles/styles.dart';
import 'package:restaurant_app/ui/auth/bloc/auth_bloc.dart';

class AdminLayout extends StatelessWidget {
  const AdminLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          BlocProvider.of<AuthBloc>(context).add(const LogOut());
          Navigator.popAndPushNamed(context, '/');
        },
        tooltip: 'Log out',
        child: const Icon(Icons.logout),
      ),
      body: SafeArea(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 16),
                child: Text(
                  'Hi, Admin',
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
                      Navigator.pushNamed(context, '/to-approve');
                    },
                    child: Text(
                      'Manage Shop Approval',
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
                      Navigator.pushNamed(context, '/manage-approve');
                    },
                    child: Text(
                      'Manage Approved Shops',
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
                      Navigator.pushNamed(context, '/bug-reports');
                      // Perform registration functionality here
                    },
                    child: Text(
                      'Manage Bug Reports',
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
            ]),
      ),
    );
  }
}
