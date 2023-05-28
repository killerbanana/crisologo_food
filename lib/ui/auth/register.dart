import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/styles/styles.dart';
import 'package:restaurant_app/ui/auth/bloc/auth_bloc.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool loading = false;

  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController contactCtrl = TextEditingController();

  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference _shop =
      FirebaseFirestore.instance.collection('shops');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Register',
          style: textInter.copyWith(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
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
                      SizedBox(height: 40.0),
                      Container(
                        width: double.infinity,
                        child: CupertinoTextField(
                          padding: EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 20.0),
                          placeholder: 'Name or Shop Name',
                          controller: nameCtrl,
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
                          padding: EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 20.0),
                          placeholder: 'Contact Number',
                          keyboardType: TextInputType.number,
                          controller: contactCtrl,
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
                          padding: EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 20.0),
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
                          padding: EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 20.0),
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
                        ),
                      ),
                      SizedBox(height: 40.0),
                      Container(
                        width: double.infinity,
                        child: CupertinoButton.filled(
                          onPressed: () async {
                            setState(() {
                              loading = true;
                            });
                            try {
                              UserCredential userCredential =
                                  await _auth.createUserWithEmailAndPassword(
                                email: emailCtrl.text,
                                password: passwordCtrl.text,
                              );
                              User? user = userCredential.user;
                              await _usersCollection.doc(user?.uid).set({
                                'id': user?.uid,
                                'email': emailCtrl.text,
                                'displayName': nameCtrl.text,
                                'role': "buyer",
                                'status': 'approved',
                                'imageUrl':
                                    'https://firebasestorage.googleapis.com/v0/b/restaurant-ilocos.appspot.com/o/noimage.png?alt=media&token=a0b3b506-ee61-40cb-b6bc-d250c2cef0c9'
                              }).then((value) {
                                BlocProvider.of<AuthBloc>(context)
                                    .add(GetAuth());
                                setState(() {
                                  loading = false;
                                });
                                Navigator.popAndPushNamed(
                                  context,
                                  '/success-registration',
                                  arguments: 'Buyer',
                                );
                              });
                            } catch (e) {
                              var snackBar = SnackBar(
                                content: Text(e.toString()),
                                duration: Duration(seconds: 5),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              setState(() {
                                loading = false;
                              });
                            }
                          },
                          child: Text(
                            'Register as Customer',
                            style: textInter.copyWith(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Container(
                        width: double.infinity,
                        child: CupertinoButton.filled(
                          onPressed: () async {
                            setState(() {
                              loading = true;
                            });
                            try {
                              UserCredential userCredential =
                                  await _auth.createUserWithEmailAndPassword(
                                email: emailCtrl.text,
                                password: passwordCtrl.text,
                              );
                              User? user = userCredential.user;
                              await _usersCollection.doc(user?.uid).set({
                                'id': user?.uid,
                                'email': emailCtrl.text,
                                'displayName': nameCtrl.text,
                                'role': "merchant",
                                'status': 'for approval',
                                'imageUrl':
                                    'https://firebasestorage.googleapis.com/v0/b/restaurant-ilocos.appspot.com/o/noimage.png?alt=media&token=a0b3b506-ee61-40cb-b6bc-d250c2cef0c9',
                              }).then((value) async {
                                await _shop.doc(user?.uid).set({
                                  'id': user?.uid,
                                  'name': nameCtrl.text,
                                  'closing': '11 PM',
                                  'contact': contactCtrl.text,
                                  'imageUrl':
                                      'https://firebasestorage.googleapis.com/v0/b/restaurant-ilocos.appspot.com/o/noimage.png?alt=media&token=a0b3b506-ee61-40cb-b6bc-d250c2cef0c9',
                                  'instagram': 'https://www.instagram.com',
                                  'intro': 'Sample intro',
                                  'isOpen': true,
                                  'type': 'shop',
                                  'opening': '10 AM',
                                }).then((value) {
                                  setState(() {
                                    loading = false;
                                  });
                                  BlocProvider.of<AuthBloc>(context)
                                      .add(GetAuth());
                                  Navigator.popAndPushNamed(
                                    context,
                                    '/success-registration',
                                    arguments: 'Seller',
                                  );
                                });
                              });
                            } catch (e) {
                              var snackBar = SnackBar(
                                content: Text(e.toString()),
                                duration: Duration(seconds: 5),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              setState(() {
                                loading = false;
                              });
                            }
                          },
                          child: Text(
                            'Register as Merchant',
                            style: textInter.copyWith(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      GestureDetector(
                        onTap: () {
                          Navigator.popAndPushNamed(context, '/login');
                        },
                        child: Text(
                          'Already have an account? Login',
                          style: textInter.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0XFF66676E),
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
  }
}
