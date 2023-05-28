import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_app/styles/styles.dart';
import 'package:restaurant_app/ui/auth/login.dart';
import 'package:restaurant_app/ui/auth/register.dart';
import 'package:restaurant_app/ui/home/bloc/home_bloc.dart';
import 'package:restaurant_app/ui/home/components/home_body.dart';
import 'package:restaurant_app/ui/home/components/slider.dart';
import 'package:restaurant_app/ui/profile/profile_layout.dart';
import 'package:restaurant_app/ui/search/search.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
      HomeBody(),
      Search(),
      ProfileLayout(),
    ];
    return BlocBuilder<HomeBloc, HomeState>(builder: (ctx, state) {
      return Scaffold(
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: _widgetOptions.elementAt(state.selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_box),
              label: 'Profile',
            ),
          ],
          currentIndex: state.selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: (index) {
            BlocProvider.of<HomeBloc>(ctx).add(SelectIndexEvent(index: index));
          },
        ),
      );
    });
  }
}
