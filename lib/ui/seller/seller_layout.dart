import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_app/styles/styles.dart';

import '../auth/bloc/auth_bloc.dart';

class SellerLayout extends StatelessWidget {
  const SellerLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> shop_products =
        FirebaseFirestore.instance.collection('shop_products').snapshots();

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
                'Hi, Seller',
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
                    // Perform registration functionality here
                    // Navigator.pushNamed(context, '/add-menu');
                  },
                  child: Text(
                    'View Profile',
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
                    Navigator.pushNamed(context, '/add-menu');
                  },
                  child: Text(
                    'Manage Menu',
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
          ],
        ),
      ),
    );
  }
}
