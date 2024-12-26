import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gestao_financeira/views/onboarding_screen.dart';
import 'package:gestao_financeira/views/dashboard_screen.dart';
import 'package:provider/provider.dart';
import 'package:gestao_financeira/services/auth_service.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  bool _hasSeenOnboarding = false;
  bool _isLoggedIn = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAppState();
  }

  Future<void> _checkAppState() async {
    final prefs = await SharedPreferences.getInstance();
    final authService = Provider.of<AuthService>(context, listen: false);
    final user = authService.getCurrentUser();

    setState(() {
      _hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;
      _isLoggedIn = user != null;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_isLoggedIn) {
      return const DashboardScreen();
    } else if (_hasSeenOnboarding) {
      return OnboardingScreen(); // Caso o usuário já tenha visto o onboarding
    } else {
      return OnboardingScreen(); // Caso o usuário não tenha visto o onboarding
    }
  }
}

