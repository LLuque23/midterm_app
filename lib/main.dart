import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:midterm_app/screens/home_screen.dart';
import 'package:midterm_app/screens/landing_screen.dart';
import 'package:midterm_app/screens/register_screen.dart';
import 'package:midterm_app/screens/sign_in_screen.dart';
import 'package:midterm_app/screens/user_profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Midterm App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: LandingScreen(),
      routes: <String, WidgetBuilder>{
        '/sign-in': (BuildContext context) => const SignInScreen(),
        '/register': (BuildContext context) => const RegisterScreen(),
        '/home': (BuildContext context) => HomeScreen(),
        '/user-profile': (BuildContext context) => const UserProfileScreen()
      },
    );
  }
}
