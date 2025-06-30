import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print('Login error: \$e');
      return null;
    }
  }

  static Future<String?> registerWithEmail(
    String fullName,
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Actualizar displayName en el perfil del usuario
      await userCredential.user?.updateDisplayName(fullName);
      await userCredential.user?.reload(); // Refrescar datos del usuario

      return null; // Éxito
    } on FirebaseAuthException catch (e) {
      return e.message; // Devuelve mensaje de error para mostrar en UI
    } catch (e) {
      return e.toString();
    }
  }

  static Future<String?> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null; // Éxito
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No existe una cuenta con ese correo electrónico.';
      }
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }
}
