import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gestao_financeira/services/auth_service.dart';
import 'package:gestao_financeira/views/dashboard_screen.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});

  final AuthService authService = AuthService();

  Future<void> _setUserStatus(bool isLoggedIn, String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);
    await prefs.setBool('isLoggedIn', isLoggedIn);
    await prefs.setString('userId', userId);
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      final user = await authService.signInWithGoogle();

      if (user != null) {
        await _setUserStatus(true, user.uid);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao realizar login')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao realizar login: $e')),
      );
    }
  }

  Future<void> _signIn(BuildContext context) async {
    try {
      final user = await authService.signInWithGoogle();

      if (user != null) {
        await _setUserStatus(true, user.uid);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao realizar sign in')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao realizar sign in: $e')),
      );
    }
  }

  void _handleMenuSelection(BuildContext context, String value) {
    switch (value) {
      case 'Inicio':
        Navigator.pushReplacementNamed(context, '/');
        break;
      case 'Sobre':
        Navigator.pushNamed(context, '/sobre');
        break;
      case 'Help':
        Navigator.pushNamed(context, '/help');
        break;
      case 'Login':
        Navigator.pushNamed(context, '/login');
        break;
      case 'Sign In':
        Navigator.pushNamed(context, '/sign_in');
        break;
      // Adicionar lógica para outras opções do menu, se necessário
    }
  }

  Future<void> _precacheImage(BuildContext context) async {
    await precacheImage(const AssetImage('assets/images/background.jpg'), context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _precacheImage(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Gestão Financeira',
                style: TextStyle(
                  fontFamily: 'Roboto', // Fonte mais bonita
                  fontSize: 24, // Aumentar o tamanho da fonte
                  fontWeight: FontWeight.bold,
                  color: Colors.tealAccent, // Cor que combina com o background verde
                ),
                textAlign: TextAlign.center, // Centralizar o texto
              ),
              backgroundColor: Colors.teal,
              centerTitle: true, // Centralizar o título
              actions: [
                PopupMenuButton<String>(
                  onSelected: (value) => _handleMenuSelection(context, value),
                  itemBuilder: (BuildContext context) {
                    return [
                      const PopupMenuItem<String>(
                        value: 'Inicio',
                        child: Text('Inicio'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Sobre',
                        child: Text('Sobre'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Help',
                        child: Text('Help'),
                      ),
                      const PopupMenuDivider(),
                      const PopupMenuItem<String>(
                        value: 'Login',
                        child: Text('Login'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Sign In',
                        child: Text('Sign In'),
                      ),
                    ];
                  },
                  icon: const Icon(Icons.menu),
                ),
              ],
            ),
            body: Stack(
              children: [
                // Imagem de fundo
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/background.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Conteúdo principal
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5), // Cor preta com 50% de opacidade
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0)), // Bordas arredondadas
                        ),
                        child: const Text(
                          'Gestão Financeira',
                          style: TextStyle(
                            fontFamily: 'Roboto', // Fonte mais bonita
                            fontSize: 32, // Aumentar o tamanho da fonte
                            fontWeight: FontWeight.bold,
                            color: Colors.tealAccent, // Cor que combina com o verde
                            shadows: [
                              Shadow(
                                blurRadius: 10.0,
                                color: Colors.black45,
                                offset: Offset(2.0, 2.0),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center, // Centralizar o texto
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5), // Cor preta com 50% de opacidade
                          borderRadius: BorderRadius.circular(10), // Bordas arredondadas
                        ),
                        child: const Text(
                          'Gerencie suas finanças de forma fácil e eficiente.',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Botões de Login e Sign In
                      ElevatedButton.icon(
                        onPressed: () => Navigator.pushNamed(context, '/login'),
                        icon: const Icon(Icons.login, size: 24),
                        label: const Text('Login'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white, backgroundColor: Colors.orange, // Cor do texto e ícone
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () => Navigator.pushNamed(context, '/sign_in'),
                        icon: const Icon(Icons.person_add, size: 24),
                        label: const Text('Sign In'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white, backgroundColor: Colors.blue, // Cor do texto e ícone
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
