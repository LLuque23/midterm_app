import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:midterm_app/screens/user_info_screen.dart';
import 'package:midterm_app/screens/user_profile_screen.dart';
import 'package:midterm_app/services/firebase_service.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        actions: [
          IconButton(
            onPressed: () {
              _userLogout(context);
            },
            icon: const FaIcon(FontAwesomeIcons.signOutAlt),
            tooltip: 'LOGOUT',
          )
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _firebaseService
            .userDocumentStream(_firebaseService.currentUser()!.uid),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.green,
              ),
            );
          }
          if (snapshot.data!.exists) {
            return userList();
          }
          return const UserInfoScreen();
        },
      ),
    );
  }
}

Widget userList() {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseService().users,
    builder: (BuildContext context, snapshot) {
      if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      }
      if (!snapshot.hasData) {
        return const Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.green,
          ),
        );
      }
      return ListView(
        children: snapshot.data!.docs.map((doc) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                '/user-profile',
                arguments: UserProfileArguments(doc),
              );
            },
            child: Material(
              elevation: 20,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 8,
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  border: Border(
                      left: BorderSide(width: 2.5, color: Colors.black),
                      right: BorderSide(width: 2.5, color: Colors.black),
                      bottom: BorderSide(width: 2.5, color: Colors.black)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.network(
                      doc['url'],
                      height: 30,
                      width: 30,
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              doc['fName'] + ' ' + doc['lName'],
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text('User Joined on: ' +
                                doc['creation-date'].toDate().toString()),
                          ],
                        )
                      ],
                    ),
                    const Icon(FontAwesomeIcons.arrowAltCircleRight)
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      );
    },
  );
}

Future<void> _userLogout(BuildContext context) async {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Colors.red,
              ),
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Colors.green,
              ),
              child: const Text('YES'),
              onPressed: () async {
                try {
                  await FirebaseService().signOut();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.blueGrey,
                      content: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'User successfully logged out.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      duration: Duration(seconds: 5),
                    ),
                  );
                  Navigator.of(context).pop();
                } catch (error) {
                  throw ErrorDescription(error.toString());
                }
              },
            ),
          ],
        );
      });
}
