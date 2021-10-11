import 'package:flutter/material.dart';
import 'package:midterm_app/services/firebase_service.dart';

import 'home_screen.dart';
import 'sign_in_screen.dart';

class LandingScreen extends StatelessWidget {
  LandingScreen({Key? key}) : super(key: key);

  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: _firebaseService.currentUserStream(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return HomeScreen();
          }
          return const SignInScreen();
        },
      ),
    );
  }
}
