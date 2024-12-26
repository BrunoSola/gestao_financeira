import 'package:flutter/material.dart';
import 'package:gestao_financeira/utils/constants.dart';

class SobreScreen extends StatelessWidget {
  const SobreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sobre o App',
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
            Navigator.pop(context); // Voltar para a tela anterior
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
          padding: const EdgeInsets.all(16.0), // Espaçamento da borda azul
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0), // Espaçamento interno branco
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center, // Centraliza horizontalmente
                  children: [
                    Text(
                      'Gestão Financeira',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Este aplicativo foi desenvolvido para ajudar você a gerenciar suas finanças de forma fácil e eficiente. '
                      'Com ele, você pode adicionar e acompanhar suas rendas e despesas, criar e gerenciar carteiras, e muito mais.',
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Funcionalidades:',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '- Adicionar e acompanhar rendas e despesas\n'
                      '- Criar e gerenciar carteiras\n'
                      '- Guardar e recuperar dinheiro das carteiras\n'
                      '- Editar rendas e despesas',
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
