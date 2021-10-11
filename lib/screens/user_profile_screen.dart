import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as UserProfileArguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(args.user['fName'] + " " + args.user['lName']),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(args.user['url']),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Bio",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(args.user['bio']),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Hometown",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(args.user['hometown']),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Age",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(args.user['age'])
          ],
        ),
      ),
    );
  }
}

class UserProfileArguments {
  final QueryDocumentSnapshot<Object?> user;

  UserProfileArguments(this.user);
}

// class UserProfileArguments {
//   final String fName;
//   final String lName;
//   final String picture;
//   final String bio;
//   final String hometown;
//   final String age;

//   UserProfileArguments(
//       this.fName, this.lName, this.picture, this.bio, this.hometown, this.age);
// }
