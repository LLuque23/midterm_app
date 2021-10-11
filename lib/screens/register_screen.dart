import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:midterm_app/components/constants.dart';
import 'package:midterm_app/components/snackbar.dart';
import 'package:midterm_app/services/firebase_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formkey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String fName = '';
  String lName = '';
  String hometown = '';
  String age = '';
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
        : Scaffold(
            appBar: AppBar(
              title: const Text('Register'),
            ),
            body: Form(
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
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
                          email = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter Email";
                          }
                        },
                        textAlign: TextAlign.center,
                        decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Email',
                          prefixIcon: const Icon(
                            Icons.email,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter Password";
                          }
                        },
                        onChanged: (value) {
                          password = value;
                        },
                        textAlign: TextAlign.center,
                        decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Password',
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Colors.green,
                            )),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formkey.currentState!.validate()) {
                              setState(() {
                                isloading = true;
                              });

                              try {
                                await _firebaseService.createEmailAndPassword(
                                    email, password);
                                Navigator.of(context).pop();
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'weak-password') {
                                  snackbar(context,
                                      'The password provided is too weak.', 3);
                                } else if (e.code == 'email-already-in-use') {
                                  snackbar(
                                      context,
                                      'The account already exists for that email.',
                                      3);
                                }
                              } catch (e) {
                                snackbar(context, e.toString(), 3);
                              }

                              setState(() {
                                isloading = false;
                              });
                            }
                          },
                          child: const Text("Create Account"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
