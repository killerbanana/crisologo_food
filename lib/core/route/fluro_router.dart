// ignore_for_file: prefer_const_constructors, duplicate_import

/*This file uses Fluro [https://pub.dev/packages/fluro] because fluro is a
straightforward package when it comes to routing with params

i.e - when viewing the product
OLD URL - host:port#/#/product/details
CURRENT WITH FLURO - host:port#/#/product/details/Grocer-BunBox?s.KsJnE68ocyLovu3Hn268?sku=GBBOX30

*NOTE SUBJECT TO CHANGE INCLUDING THE LINK FORMAT
 */
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/core/common/enum.dart';
import 'package:restaurant_app/ui/admin/admin_layout.dart';
import 'package:restaurant_app/ui/admin/bug_reports.dart';
import 'package:restaurant_app/ui/admin/edit_store_location.dart';
import 'package:restaurant_app/ui/admin/manage_approved.dart';
import 'package:restaurant_app/ui/admin/to_approve.dart';
import 'package:restaurant_app/ui/auth/account_status.dart';
import 'package:restaurant_app/ui/auth/change_password.dart';
import 'package:restaurant_app/ui/auth/login.dart';
import 'package:restaurant_app/ui/auth/register.dart';
import 'package:restaurant_app/ui/auth/success_register.dart';
import 'package:restaurant_app/ui/home/components/product_fullscreen.dart';
import 'package:restaurant_app/ui/home/home_layout.dart';
import 'package:restaurant_app/ui/profile/profile_layout.dart';
import 'package:restaurant_app/ui/seller/add_menu.dart';
import 'package:restaurant_app/ui/seller/add_menu_form.dart';
import 'package:restaurant_app/ui/seller/components/edit_product.dart';
import 'package:restaurant_app/ui/seller/components/edit_profile.dart';
import 'package:restaurant_app/ui/seller/seller_layout.dart';

import '../../ui/auth/bloc/auth_bloc.dart';

class FloruRouter {
  static FluroRouter fluroRouter = FluroRouter();

  static var homeScreenHandler = Handler(
      handlerFunc: ((BuildContext? context, Map<String, dynamic> params) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    final FirebaseAuth _auth = FirebaseAuth.instance;
    // return TestView();
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state.auth == AuthenticationState.authenticated) {
        return FutureBuilder<DocumentSnapshot>(
          future: users.doc(_auth.currentUser!.uid).get(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            if (snapshot.hasData && !snapshot.data!.exists) {
              return Text("Document does not exist");
            }
            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;

              switch (data['role']) {
                case 'buyer':
                  if (data['status'] != 'approved') {
                    return AccountStatus(
                      status: data['status'],
                    );
                  } else {
                    return HomeLayout();
                  }

                case 'merchant':
                  if (data['status'] != 'approved') {
                    return AccountStatus(
                      status: data['status'],
                    );
                  } else {
                    return SellerLayout();
                  }
                case 'admin':
                  return AdminLayout();
              }
            }
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          },
        );
      } else {
        return LogIn();
      }
    });
  }));

  static var loginScreenHandler = Handler(
      handlerFunc: ((BuildContext? context, Map<String, dynamic> params) {
    return LogIn();
  }));

  static var registerScreenHandler = Handler(
      handlerFunc: ((BuildContext? context, Map<String, dynamic> params) {
    return Register();
  }));

  static var successRegistrationHandler = Handler(
      handlerFunc: ((BuildContext? context, Map<String, dynamic> params) {
    return SuccessRegister();
  }));

  static var addMenuHandler = Handler(
      handlerFunc: ((BuildContext? context, Map<String, dynamic> params) {
    return AddMenu();
  }));

  static var addMenuFormHandler = Handler(
      handlerFunc: ((BuildContext? context, Map<String, dynamic> params) {
    return AddMenuForm();
  }));

  static var profileHandler = Handler(
      handlerFunc: ((BuildContext? context, Map<String, dynamic> params) {
    return ProfileLayout();
  }));

  static var editProfileSellerHandler = Handler(
      handlerFunc: ((BuildContext? context, Map<String, dynamic> params) {
    return EditProfileSeller();
  }));

  static var changePasswordHandler = Handler(
      handlerFunc: ((BuildContext? context, Map<String, dynamic> params) {
    return ChangePassword();
  }));

  static var editProductHandler = Handler(
      handlerFunc: ((BuildContext? context, Map<String, dynamic> params) {
    return EditProduct();
  }));

  static var toApproveHandler = Handler(
      handlerFunc: ((BuildContext? context, Map<String, dynamic> params) {
    return ToApprove();
  }));

  static var manageApproveHandler = Handler(
      handlerFunc: ((BuildContext? context, Map<String, dynamic> params) {
    return ManageApproved();
  }));

  static var editLocationHandler = Handler(
      handlerFunc: ((BuildContext? context, Map<String, dynamic> params) {
    return EditStoreLocation();
  }));

  static var bugReportHandler = Handler(
      handlerFunc: ((BuildContext? context, Map<String, dynamic> params) {
    return BugReports();
  }));

  static var productFullscreenHandler = Handler(
      handlerFunc: ((BuildContext? context, Map<String, dynamic> params) {
    return ProductFullScreen();
  }));

  static initRoutes() {
    fluroRouter.define('/',
        handler: homeScreenHandler, transitionType: TransitionType.fadeIn);

    fluroRouter.define('/login',
        handler: loginScreenHandler, transitionType: TransitionType.fadeIn);

    fluroRouter.define('/register',
        handler: registerScreenHandler, transitionType: TransitionType.fadeIn);

    fluroRouter.define('/success-registration',
        handler: successRegistrationHandler,
        transitionType: TransitionType.fadeIn);

    fluroRouter.define('/add-menu',
        handler: addMenuHandler, transitionType: TransitionType.fadeIn);

    fluroRouter.define('/add-menu-form',
        handler: addMenuFormHandler, transitionType: TransitionType.fadeIn);

    fluroRouter.define('/profile',
        handler: profileHandler, transitionType: TransitionType.fadeIn);

    fluroRouter.define('/edit-profile-seller',
        handler: editProfileSellerHandler,
        transitionType: TransitionType.fadeIn);

    fluroRouter.define('/change-password',
        handler: changePasswordHandler, transitionType: TransitionType.fadeIn);

    fluroRouter.define('/product-edit',
        handler: editProductHandler, transitionType: TransitionType.fadeIn);

    fluroRouter.define('/to-approve',
        handler: toApproveHandler, transitionType: TransitionType.fadeIn);

    fluroRouter.define('/manage-approve',
        handler: manageApproveHandler, transitionType: TransitionType.fadeIn);

    fluroRouter.define('/edit-location',
        handler: editLocationHandler, transitionType: TransitionType.fadeIn);

    fluroRouter.define('/bug-reports',
        handler: bugReportHandler, transitionType: TransitionType.fadeIn);

    fluroRouter.define('/product-fullscreen',
        handler: productFullscreenHandler,
        transitionType: TransitionType.fadeIn);
  }
}
