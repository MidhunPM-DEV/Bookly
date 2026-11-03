import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthStore extends ChangeNotifier {
  AuthStore._();

  static final instance = AuthStore._();

  static const _nameKey = 'auth.name';

  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn.instance;

  bool _isSignedIn = false;
  String? _name;
  String? _email;
  StreamSubscription<User?>? _authSubscription;

  bool get isSignedIn => _isSignedIn;
  String? get userName => _name;
  String? get userEmail => _email;

  Future<void> initialize() async {
    await _googleSignIn.initialize();
    await _syncUser(_auth.currentUser);
    _authSubscription ??= _auth.authStateChanges().listen(_syncUser);
  }

  Future<String?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim().toLowerCase(),
        password: password,
      );
      await credential.user?.updateDisplayName(name.trim());
      await _syncUser(_auth.currentUser);
      return null;
    } on FirebaseAuthException catch (error) {
      return _messageFor(error);
    }
  }

  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim().toLowerCase(),
        password: password,
      );
      await _syncUser(_auth.currentUser);
      return null;
    } on FirebaseAuthException catch (error) {
      return _messageFor(error);
    }
  }

  Future<String?> signInWithGoogle() async {
    try {
      final account = await _googleSignIn.authenticate();
      final authentication = account.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: authentication.idToken,
      );
      await _auth.signInWithCredential(credential);
      await _syncUser(_auth.currentUser);
      return null;
    } on FirebaseAuthException catch (error) {
      return _messageFor(error);
    } catch (_) {
      return 'Google sign-in was cancelled or unavailable.';
    }
  }

  Future<void> signOut() async {
    await Future.wait([_auth.signOut(), _googleSignIn.signOut()]);
  }

  Future<void> _syncUser(User? user) async {
    if (user == null) {
      _isSignedIn = false;
      _name = null;
      _email = null;
    } else {
      final preferences = await SharedPreferences.getInstance();
      _name = user.displayName ?? preferences.getString(_nameKey);
      _email = user.email;
      _isSignedIn = true;
      if (_name != null) await preferences.setString(_nameKey, _name!);
    }
    notifyListeners();
  }

  String _messageFor(FirebaseAuthException error) {
    switch (error.code) {
      case 'email-already-in-use':
        return 'An account already exists for this email.';
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return 'Email or password is incorrect.';
      case 'weak-password':
        return 'Choose a stronger password.';
      case 'invalid-email':
        return 'Enter a valid email address.';
      case 'network-request-failed':
        return 'Check your internet connection and try again.';
      default:
        return error.message ?? 'Authentication failed. Please try again.';
    }
  }
}
