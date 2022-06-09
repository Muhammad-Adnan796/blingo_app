import 'dart:io';

import 'package:blingo2/Models/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  UserModel? userModel;

  // Sign In with google method
  Future<String?> signInwithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await _auth.signInWithCredential(credential).then((value) async {
        String email =
            value.user!.email!.substring(0, value.user!.email!.indexOf('@'));
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set({
          'Username': email,
          'email': FirebaseAuth.instance.currentUser!.email!,
          'bio': 'Edit profile to update bio',
          'diamonds': 0,
          'followers': 0,
          'likes': 0,
          'following': 0,
          'posts': 0,
          // contact:  _mobileController.text,
          'displayName': FirebaseAuth.instance.currentUser!.displayName,
          'photoUrl':
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ6TaCLCqU4K0ieF27ayjl51NmitWaJAh_X0r1rLX4gMvOe0MDaYw&s',
          'id': FirebaseAuth.instance.currentUser!.uid,
        });
      });
    } on FirebaseAuthException catch (e) {
      print(e.message);
      throw e;
    }
  }

  // Sign out from google method
  Future<void> signOutFromGoogle() async {
    await _googleSignIn.signOut();
    // await FacebookAuth.instance.logOut();
    await _auth.signOut();
  }
  // Future<Resource?> signInWithFacebook() async {
  //   try {
  //     final LoginResult result = await FacebookAuth.instance.login();
  //     switch (result.status) {
  //       case LoginStatus.success:
  //         final AuthCredential facebookCredential =
  //             FacebookAuthProvider.credential(result.accessToken!.token);
  //         final userCredential =
  //             await _auth.signInWithCredential(facebookCredential);
  //         return Resource(status: Status.Success);
  //       case LoginStatus.cancelled:
  //         return Resource(status: Status.Cancelled);
  //       case LoginStatus.failed:
  //         return Resource(status: Status.Error);
  //       default:
  //         return null;
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     throw e;
  //   }
  // }
}
