import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/core/boot/environment.dart';
import 'package:restaurant_app/core/route/fluro_router.dart';
import 'package:restaurant_app/ui/auth/bloc/auth_bloc.dart';
import 'package:restaurant_app/ui/home/bloc/home_bloc.dart';
import 'package:restaurant_app/ui/search/bloc/search_bloc.dart';
import 'package:restaurant_app/ui/seller/bloc/product_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Environment.initialize();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBdqoqIvMNVCzbebzOzu0mHvYMxZuaSfzQ",
      authDomain: "restaurant-ilocos.firebaseapp.com",
      projectId: "restaurant-ilocos",
      storageBucket: "restaurant-ilocos.appspot.com",
      messagingSenderId: "215246146928",
      appId: "1:215246146928:web:0de71fd0aaa97cc0bf53b5",
      measurementId: "G-8VHPE41SMR",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: ((context) => HomeBloc()),
        ),
        BlocProvider(
          create: ((context) => SearchBloc()),
        ),
        BlocProvider(
          create: ((context) =>
              AuthBloc(FirebaseAuth.instance)..add(GetAuth())),
        ),
        BlocProvider(
          create: ((context) => ProductBloc()..add(GetCategoryEvent())),
        ),
      ],
      child: MaterialApp(
        title: 'Resto App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        onGenerateRoute: FloruRouter.fluroRouter.generator,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    FloruRouter.initRoutes();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
