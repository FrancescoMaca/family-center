
import 'package:family_center/extensions/string_ext.dart';
import 'package:fancy_snackbar/fancy_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void showSignInError(BuildContext ctx, Object e) {
  e as FirebaseAuthException;

  String title = e.code.split('-').map((word) => word.capitalize()).join(' ');

  final Map<String, String> errorToMessage = {
    'invalid-email': 'The email address is badly formatted.',
    'invalid-credential': 'The email address is not associated with any accounts.',
    'user-disabled': 'This user account has been disabled.',
    'user-not-found': 'No user found with this email.',
    'wrong-password': 'Wrong password provided.',
    'email-already-in-use': 'An account already exists with this email.',
    'weak-password': 'The password provided is too weak.',
    'operation-not-allowed': 'Email/password accounts are not enabled.',
  };

  FancySnackbar.showSnackbar(
    ctx,
    title: title,
    snackBarType: FancySnackBarType.error,
    message: errorToMessage[e.code] ?? "This error is not caused by the credentials, but by an external factor such as connection."
  );
}