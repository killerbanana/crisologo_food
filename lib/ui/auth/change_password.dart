import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/styles/styles.dart';
import 'package:restaurant_app/ui/auth/bloc/auth_bloc.dart';

class ChangePassword extends StatelessWidget {
  const ChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController passwordCtrl = TextEditingController();
    final TextEditingController confirmPasswordCtrl = TextEditingController();

    final FirebaseAuth _auth = FirebaseAuth.instance;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Change Password',
          style: textInter.copyWith(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  child: CupertinoTextField(
                    padding:
                        EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                    placeholder: 'Password',
                    controller: passwordCtrl,
                    obscureText: true,
                    decoration: BoxDecoration(
                      color: CupertinoColors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          offset: Offset(0, 2),
                          blurRadius: 4.0,
                        ),
                      ],
                    ),
                    onChanged: (value) {
                      BlocProvider.of<AuthBloc>(context)
                          .add(const AddError(withError: false));
                    },
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  width: double.infinity,
                  child: CupertinoTextField(
                    padding:
                        EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                    placeholder: 'Confirm Password',
                    controller: confirmPasswordCtrl,
                    obscureText: true,
                    decoration: BoxDecoration(
                      color: CupertinoColors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          offset: Offset(0, 2),
                          blurRadius: 4.0,
                        ),
                      ],
                    ),
                    onChanged: (value) {
                      BlocProvider.of<AuthBloc>(context)
                          .add(const AddError(withError: false));
                    },
                  ),
                ),
                SizedBox(height: 40.0),
                BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
                  return Visibility(
                    visible: state.withError,
                    child: Text(
                      'Password Mismatch',
                      style: textInter.copyWith(
                        fontSize: 12,
                        color: Colors.red,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  );
                }),
                Container(
                  width: double.infinity,
                  child: CupertinoButton.filled(
                    onPressed: () async {
                      User? user = _auth.currentUser;
                      if (user != null) {
                        if (passwordCtrl.text == confirmPasswordCtrl.text) {
                          await user
                              .updatePassword(passwordCtrl.text)
                              .then((value) {
                            BlocProvider.of<AuthBloc>(context)
                                .add(const LogOut());
                            Navigator.popAndPushNamed(context, '/');
                          }).onError((error, stackTrace) {
                            const snackBar = SnackBar(
                              content: Text(
                                  'Cannot change Password. Please re login and try to change password again.'),
                              duration: Duration(seconds: 5),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          });
                        } else {
                          BlocProvider.of<AuthBloc>(context)
                              .add(const AddError(withError: true));
                        }
                      }
                    },
                    child: Text(
                      'Save',
                      style: textInter.copyWith(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
    ;
  }
}
