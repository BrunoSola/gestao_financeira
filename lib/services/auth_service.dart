import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Método para fazer login com o Google
  Future<User?> signInWithGoogle() async {
    try {
      await signOut();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // O usuário cancelou o login
        throw FirebaseAuthException(
          code: 'ERROR_CANCELLED_BY_USER',  // Adicionando o código de erro apropriado
          message: 'Login cancelado pelo usuário',
        );
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        await _checkAndCreateUser(user);
        await _saveUserIdToPreferences(user.uid);
        return user;
      } else {
        // Erro de autenticação
        throw FirebaseAuthException(
          code: 'ERROR_AUTHENTICATION_FAILED',  // Fornecendo o código de erro
          message: 'Erro ao autenticar o usuário.',
        );
      }
    } catch (e) {
      print("Erro ao tentar fazer login com o Google: $e");

      // Lançando a exceção corretamente com o código de erro
      if (e is FirebaseAuthException) {
        throw FirebaseAuthException(
          code: e.code,  // Passando o código de erro original
          message: e.message ?? 'Erro desconhecido.',  // Mensagem do erro
        );
      } else {
        throw Exception("Falha ao realizar login. Tente novamente.");
      }
    }
  }

  // Método para registro com Google
  Future<User?> signUpWithGoogle() async {
    return await signInWithGoogle();
  }

  // Método para fazer login com email e senha
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? user = userCredential.user;
      if (user != null) {
        await _saveUserIdToPreferences(user.uid);
        return user;
      } else {
        throw FirebaseAuthException(
          code: 'ERROR_AUTHENTICATION_FAILED',
          message: 'Erro ao autenticar o usuário.',
        );
      }
    } catch (e) {
      print("Erro ao tentar fazer login com email e senha: $e");
      if (e is FirebaseAuthException) {
        throw FirebaseAuthException(
          code: e.code,
          message: e.message ?? 'Erro desconhecido.',
        );
      } else {
        throw Exception("Falha ao realizar login. Tente novamente.");
      }
    }
  }

  // Método para registrar com email e senha
  Future<User?> signUpWithEmail(String email, String password) async {
    try {
      final signInMethods = await _auth.fetchSignInMethodsForEmail(email);

      if (signInMethods.isNotEmpty) {
        throw FirebaseAuthException(
          code: 'ERROR_EMAIL_ALREADY_IN_USE',
          message: 'E-mail já cadastrado.',
        );
      }

      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? user = userCredential.user;
      if (user != null) {
        await _checkAndCreateUser(user);
        await _saveUserIdToPreferences(user.uid);
        return user;
      } else {
        throw FirebaseAuthException(
          code: 'ERROR_AUTHENTICATION_FAILED',
          message: 'Erro ao autenticar o usuário.',
        );
      }
    } catch (e) {
      print("Erro ao tentar registrar com email e senha: $e");
      if (e is FirebaseAuthException) {
        throw FirebaseAuthException(
          code: e.code,
          message: e.message ?? 'Erro desconhecido.',
        );
      } else {
        throw Exception("Falha ao realizar registro. Tente novamente.");
      }
    }
  }

  // Verifica se o usuário já existe e cria no Firestore se não existir
  Future<void> _checkAndCreateUser(User user) async {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

    if (!userDoc.exists) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'email': user.email,
        'name': user.displayName,
        'photoUrl': user.photoURL, // Adiciona foto do usuário, se disponível
        'totalRendas': 0.0,
        'totalDespesas': 0.0,
        'totalEconomias': 0.0,
      });
    }
  }

  // Salva o userId nas SharedPreferences
  Future<void> _saveUserIdToPreferences(String userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
  }

  // Método para fazer logout
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('userId'); // Agora está correto
      notifyListeners();
    } catch (e) {
      print("Erro ao tentar fazer logout: $e");
    }
  }

  // Método para obter o usuário atual
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Verifica o estado do usuário (logado ou não)
  Future<void> loadUserState() async {
    final prefs = await SharedPreferences.getInstance();
    final user = getCurrentUser();

    if (user != null) {
      await prefs.setBool('isLoggedIn', true);
    } else {
      await prefs.setBool('isLoggedIn', false);
    }

    notifyListeners();
  }
}

