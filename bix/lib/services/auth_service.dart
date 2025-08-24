import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../constants/app_constants.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email and password
  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Register with email and password
  Future<UserCredential?> registerWithEmailAndPassword(
      String email, String password, String username, String displayName) async {
    try {
      // Check if username is available
      bool isUsernameAvailable = await _isUsernameAvailable(username);
      if (!isUsernameAvailable) {
        throw Exception('Username is already taken');
      }

      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        // Create user document in Firestore
        await _createUserDocument(result.user!, username, displayName);
      }

      return result;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential result = await _auth.signInWithCredential(credential);

      if (result.user != null) {
        // Check if user document exists, if not create it
        await _createOrUpdateUserDocument(result.user!);
      }

      return result;
    } catch (e) {
      throw Exception('Google sign in failed: $e');
    }
  }

  // Sign in as guest
  Future<UserCredential?> signInAsGuest() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      
      if (result.user != null) {
        // Create guest user document
        await _createGuestUserDocument(result.user!);
      }

      return result;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      throw Exception('Sign out failed: $e');
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Update password
  Future<void> updatePassword(String newPassword) async {
    try {
      await currentUser?.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Delete account
  Future<void> deleteAccount() async {
    try {
      if (currentUser != null) {
        // Delete user document from Firestore
        await _firestore
            .collection(AppConstants.usersCollection)
            .doc(currentUser!.uid)
            .delete();
        
        // Delete user account
        await currentUser!.delete();
      }
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Get user document
  Future<UserModel?> getUserDocument(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .get();

      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user document: $e');
    }
  }

  // Check if username is available
  Future<bool> _isUsernameAvailable(String username) async {
    try {
      QuerySnapshot query = await _firestore
          .collection(AppConstants.usersCollection)
          .where('username', isEqualTo: username.toLowerCase())
          .get();

      return query.docs.isEmpty;
    } catch (e) {
      return false;
    }
  }

  // Create user document in Firestore
  Future<void> _createUserDocument(User user, String username, String displayName) async {
    final userModel = UserModel(
      uid: user.uid,
      username: username.toLowerCase(),
      email: user.email ?? '',
      displayName: displayName,
      profileImageUrl: user.photoURL,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(user.uid)
        .set(userModel.toMap());
  }

  // Create or update user document for Google sign in
  Future<void> _createOrUpdateUserDocument(User user) async {
    DocumentSnapshot doc = await _firestore
        .collection(AppConstants.usersCollection)
        .doc(user.uid)
        .get();

    if (!doc.exists) {
      // Generate unique username from email
      String username = await _generateUniqueUsername(user.email ?? user.uid);
      
      final userModel = UserModel(
        uid: user.uid,
        username: username,
        email: user.email ?? '',
        displayName: user.displayName ?? 'User',
        profileImageUrl: user.photoURL,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(user.uid)
          .set(userModel.toMap());
    } else {
      // Update existing document
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(user.uid)
          .update({
        'updatedAt': Timestamp.fromDate(DateTime.now()),
        'profileImageUrl': user.photoURL,
      });
    }
  }

  // Create guest user document
  Future<void> _createGuestUserDocument(User user) async {
    String username = await _generateUniqueUsername('guest_${user.uid}');
    
    final userModel = UserModel(
      uid: user.uid,
      username: username,
      email: '',
      displayName: 'Guest User',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(user.uid)
        .set(userModel.toMap());
  }

  // Generate unique username
  Future<String> _generateUniqueUsername(String baseUsername) async {
    String username = baseUsername.toLowerCase().replaceAll(RegExp(r'[^a-z0-9_]'), '_');
    
    if (username.length > AppConstants.maxUsernameLength) {
      username = username.substring(0, AppConstants.maxUsernameLength);
    }

    bool isAvailable = await _isUsernameAvailable(username);
    if (isAvailable) return username;

    // Add numbers until we find an available username
    int counter = 1;
    while (!isAvailable) {
      String newUsername = '${username}_$counter';
      if (newUsername.length > AppConstants.maxUsernameLength) {
        username = username.substring(0, AppConstants.maxUsernameLength - '_$counter'.length);
        newUsername = '${username}_$counter';
      }
      isAvailable = await _isUsernameAvailable(newUsername);
      if (isAvailable) return newUsername;
      counter++;
    }

    return username;
  }

  // Handle Firebase Auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Try again later.';
      case 'operation-not-allowed':
        return 'This operation is not allowed.';
      default:
        return 'Authentication failed: ${e.message}';
    }
  }
}