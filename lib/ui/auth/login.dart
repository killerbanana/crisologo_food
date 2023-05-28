import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/styles/styles.dart';
import 'package:restaurant_app/ui/auth/bloc/auth_bloc.dart';
import 'package:restaurant_app/ui/home/bloc/home_bloc.dart';

class LogIn extends StatelessWidget {
  const LogIn({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailCtrl = TextEditingController();
    final TextEditingController passwordCtrl = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login',
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
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: 'animationLogo',
                child: SizedBox(
                  height: 150.0,
                  child: Image.network(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQB_ICqCxYyXqjRtBuT3EmUjjGTTkc1wqIh4Q&usqp=CAU',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                width: double.infinity,
                child: CupertinoTextField(
                  padding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                  placeholder: 'Email',
                  controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress,
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
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                width: double.infinity,
                child: CupertinoTextField(
                  padding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                  placeholder: 'Password',
                  obscureText: true,
                  controller: passwordCtrl,
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
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                width: double.infinity,
                child: CupertinoButton.filled(
                  onPressed: () {
                    BlocProvider.of<AuthBloc>(context).add(LoginEvent(
                        email: emailCtrl.text, password: passwordCtrl.text));
                    // Perform registration functionality here
                  },
                  child: Text(
                    'Log In',
                    style: textInter.copyWith(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              GestureDetector(
                onTap: () {
                  Navigator.popAndPushNamed(context, '/register');
                },
                child: Text(
                  'Doesn’t have an account? Sign Up',
                  style: textInter.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0XFF66676E),
                  ),
                ),
              ),
              BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
                return Visibility(
                  visible: state.withError,
                  child: Text(
                    'Invalid email or password',
                    style: textInter.copyWith(
                      fontSize: 12,
                      color: Colors.red,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
