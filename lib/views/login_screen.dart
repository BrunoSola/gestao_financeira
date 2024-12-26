import 'package:flutter/material.dart';
import 'package:gestao_financeira/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:gestao_financeira/utils/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false; // Estado para controle de carregamento

  // Função para login com Google
  Future<void> _signInWithGoogle(BuildContext context, AuthService authService) async {
    setState(() {
      _isLoading = true; // Ativa o carregamento
    });
    try {
      final user = await authService.signInWithGoogle();
      setState(() {
        _isLoading = false; // Desativa o carregamento
      });
      if (user != null) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao fazer login com Google: $e')),
      );
    }
  }

  // Função para login com email e senha
  Future<void> _signInWithEmailAndPassword(BuildContext context) async {
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos.')),
      );
      return;
    }

    setState(() {
      _isLoading = true; // Ativa o carregamento
    });

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final user = await authService.signInWithEmail(email, password);
      setState(() {
        _isLoading = false; // Desativa o carregamento
      });
      if (user != null) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    } catch (e) {
      setState(() {
        _isLoading = false; // Desativa o carregamento
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao fazer login: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthService>(
      create: (context) => AuthService(),
      child: Consumer<AuthService>(
        builder: (context, authService, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Login',
                style: TextStyle(
                  fontFamily: 'Roboto', // Fonte mais bonita
                  fontSize: 24, // Aumentar o tamanho da fonte
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Cor que combina com o background verde
                ),
                textAlign: TextAlign.center, // Centralizar o texto
              ),
              backgroundColor: appBarBackgroundColor,
              centerTitle: true,  // Centralizar o título
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white), // Ícone do botão de voltar
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/'); // Voltar para a tela anterior
                },
              ),
            ),
            body: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.blueAccent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Gestão Financeira',
                          style: TextStyle(
                            fontFamily: 'Roboto', // Fonte mais bonita
                            fontSize: 28, // Aumentar o tamanho da fonte
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                          textAlign: TextAlign.center, // Centralizar o texto
                        ),
                        const SizedBox(height: 20),
                        // Campo de E-mail
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: const TextStyle(
                              color: Colors.blue, // Cor do texto do rótulo
                              fontWeight: FontWeight.bold,
                            ),
                            hintText: 'Digite seu email',
                            hintStyle: const TextStyle(
                              color: Colors.grey, // Cor da dica de texto
                            ),
                            filled: true, // Preenchimento de fundo
                            fillColor: Colors.grey.shade100, // Cor de fundo do campo
                            contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors.blue, // Cor da borda
                                width: 1.5, // Espessura da borda
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors.blue, // Cor da borda ao focar
                                width: 2.0,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors.blue, // Cor da borda quando não focado
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Campo de Senha
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Senha',
                            labelStyle: const TextStyle(
                              color: Colors.blue, // Cor do texto do rótulo
                              fontWeight: FontWeight.bold,
                            ),
                            hintText: 'Digite sua senha',
                            hintStyle: const TextStyle(
                              color: Colors.grey, // Cor da dica de texto
                            ),
                            filled: true, // Preenchimento de fundo
                            fillColor: Colors.grey.shade100, // Cor de fundo do campo
                            contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors.blue, // Cor da borda
                                width: 1.5, // Espessura da borda
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors.blue, // Cor da borda ao focar
                                width: 2.0,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors.blue, // Cor da borda quando não focado
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _isLoading
                            ? const CircularProgressIndicator() // Indicador de carregamento
                            : ElevatedButton(
                                onPressed: () => _signInWithEmailAndPassword(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white, // Cor do texto em branco
                                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                                  textStyle: const TextStyle(fontSize: 18),
                                ),
                                child: const Text('Login'),
                              ),
                        const SizedBox(height: 20),
                        _isLoading
                            ? const CircularProgressIndicator() // Indicador de carregamento
                            : ElevatedButton.icon(
                                onPressed: () async {
                                  await _signInWithGoogle(context, authService);
                                },
                                icon: const Icon(Icons.login, size: 24),
                                label: const Text('Login com Google'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white, // Cor do texto em branco
                                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                                  textStyle: const TextStyle(fontSize: 18),
                                ),
                              ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/sign_in');
                          },
                          child: const Text(
                            'Ainda não é cadastrado?',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
