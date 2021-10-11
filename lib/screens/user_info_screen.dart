import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:midterm_app/components/constants.dart';
import 'package:midterm_app/services/firebase_service.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({Key? key}) : super(key: key);

  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final _formkey = GlobalKey<FormState>();
  String fName = '';
  String lName = '';
  String hometown = '';
  String age = '';
  String bio = '';
  bool isloading = false;
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return isloading
        ? const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.green,
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          )
        : Form(
            key: _formkey,
            child: Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.grey[200],
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 60),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.name,
                      onChanged: (value) {
                        fName = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter First Name";
                        }
                      },
                      textAlign: TextAlign.center,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'First Name',
                        prefixIcon: const Icon(
                          FontAwesomeIcons.user,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      keyboardType: TextInputType.name,
                      onChanged: (value) {
                        lName = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter Last Name";
                        }
                      },
                      textAlign: TextAlign.center,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Last Name',
                        prefixIcon: const Icon(
                          FontAwesomeIcons.user,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        hometown = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter Hometown";
                        }
                      },
                      textAlign: TextAlign.center,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Hometown',
                        prefixIcon: const Icon(
                          FontAwesomeIcons.home,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        age = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter Age";
                        }
                      },
                      textAlign: TextAlign.center,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Age',
                        prefixIcon: const Icon(
                          FontAwesomeIcons.hashtag,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        bio = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter Bio";
                        }
                      },
                      textAlign: TextAlign.center,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Bio',
                        prefixIcon: const Icon(
                          FontAwesomeIcons.info,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formkey.currentState!.validate()) {
                            _firebaseService.addUserDocument(
                                context, fName, lName, hometown, age, bio);
                          }
                        },
                        child: const Text("Submit Additional Info"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
