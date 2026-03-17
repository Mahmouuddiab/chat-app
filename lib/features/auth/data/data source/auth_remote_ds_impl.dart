import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app/features/auth/data/models/user_model.dart';
import 'package:injectable/injectable.dart';
import 'auth_remote_data_source.dart';

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDsImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;

  AuthRemoteDsImpl(this.firebaseAuth);

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;

      if (user == null) {
        throw Exception("User not found");
      }

      return UserModel(
        id: user.uid,
        email: user.email ?? "",
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleAuthError(e));
    }
  }

  @override
  Future<UserModel> register(String email, String password) async {
    try {
      final credential =
      await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;

      if (user == null) {
        throw Exception("User not created");
      }

      return UserModel(
        id: user.uid,
        email: user.email ?? "",
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleAuthError(e));
    }
  }

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  /// 🔥 Centralized error handling
  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return "No user found for this email";

      case 'wrong-password':
        return "Wrong password";

      case 'email-already-in-use':
        return "Email already in use";

      case 'invalid-email':
        return "Invalid email format";

      case 'weak-password':
        return "Password is too weak";

      case 'network-request-failed':
        return "No internet connection";

      default:
        return e.message ?? "Something went wrong";
    }
  }
}