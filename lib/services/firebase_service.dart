import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:midterm_app/components/snackbar.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final Reference _userProfilePicRef =
      FirebaseStorage.instance.ref('/userProfile.jpg');
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  //* MIDTERM AUTH METHODS

  //! Create new User with Email and Password
  Future<UserCredential?> createEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  //! Sign In User with Email and Password
  Future<UserCredential?> loginEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  //! Email link authentication
  sendEmailLinkAuth(String url, String userEmail) {
    var acs = ActionCodeSettings(
        url: url,
        handleCodeInApp: true,
        iOSBundleId: 'com.example.appName',
        androidPackageName: 'com.example.appName',
        androidInstallApp: true,
        androidMinimumVersion: '12');

    var emailAuth = userEmail;
    _auth
        .sendSignInLinkToEmail(email: emailAuth, actionCodeSettings: acs)
        .catchError(
            (onError) => print('Error sending email verification $onError'))
        .then((value) => print('Successfully sent email verification'));
  }

  //! Verify email link auth
  verifyEmailLinkAuth(String emailLink, String userEmail) {
    var emailAuth = userEmail;
    if (_auth.isSignInWithEmailLink(emailLink)) {
      // The client SDK will parse the code from the link for you.
      _auth
          .signInWithEmailLink(email: emailAuth, emailLink: emailLink)
          .then((value) {
        print('Successfully signed in with email link!');
      }).catchError((onError) {
        print('Error signing in with email link $onError');
      });
    }
  }

  //! Sign in with phone number
  signInWithPhoneNumber(String phoneNumber) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        } else {
          print(e);
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        //You must update your UI here and await the user to input the SMS Code
        String smsCode = 'user entered SMS code';
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: verificationId, smsCode: smsCode);
        await _auth.signInWithCredential(credential);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  //! Google Sign-In
  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return await _auth.signInWithCredential(credential);
  }

  //! Facebook Sign-In
  Future<UserCredential> signInWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance.login();
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  //! Anonymous Sign In
  Future<UserCredential> signInAnon() async {
    return await _auth.signInAnonymously();
  }

  //! Verify a user email
  verifyUserEmail() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  //! Sign Out Current User
  Future<void> signOut() async {
    await _auth.signOut();
  }

  //* EXTRA METHODS I NEED FOR MY APP

  //! Stream for listening to changes to the current User
  Stream<User?> currentUserStream() {
    return _auth.authStateChanges();
  }

  //! Create new user in firestore
  Future<void> addUserDocument(context, String fName, String lName,
      String hometown, String age, String bio) async {
    CollectionReference users = _firebaseFirestore.collection('users');

    return users
        .doc(_auth.currentUser?.uid)
        .set({
          'fName': fName,
          'lName': lName,
          'age': age,
          'hometown': hometown,
          'bio': bio,
          'creation-date': DateTime.now(),
          'url': await getProfilePicDownloadURL()
        })
        .then((value) => snackbar(context, "User Added", 5))
        .catchError(
            (error) => snackbar(context, "Failed to add user: $error", 5));
  }

  //! Get Current User
  User? currentUser() {
    return _auth.currentUser;
  }

  //! getCurrentUserDocumentStream
  userDocumentStream(String uid) {
    return _firebaseFirestore.collection('users').doc(uid).snapshots();
  }

  //! Login User with email and password and allow UI to catch error
  Future<UserCredential?> loginEmailAndPasswordErrorCatcher(
      String email, String password) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return userCredential;
  }

  //! Get downloadURL from default picture
  Future<String> getProfilePicDownloadURL() async {
    String downloadURL = await _userProfilePicRef.getDownloadURL();
    return downloadURL;
  }

  //! Get users collection stream
  Stream<QuerySnapshot> get users {
    return userCollection.snapshots();
  }
}
