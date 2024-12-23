import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal, Colors.tealAccent],
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
              child: ListView(
                children: [
                  Center(
                    child: Text(
                      'Tutorial de Uso',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSectionTitle(context, 'Como adicionar renda:'),
                  _buildSectionContent(
                    '1. Vá para a tela de rendas.\n'
                    '2. Clique no botão de adicionar renda.\n'
                    '3. Preencha os detalhes da renda e clique em salvar.',
                  ),
                  const SizedBox(height: 16),
                  _buildSectionTitle(context, 'Como adicionar despesa:'),
                  _buildSectionContent(
                    '1. Vá para a tela de despesas.\n'
                    '2. Clique no botão de adicionar despesa.\n'
                    '3. Preencha os detalhes da despesa e clique em salvar.',
                  ),
                  const SizedBox(height: 16),
                  _buildSectionTitle(context, 'Como criar e gerenciar carteiras:'),
                  _buildSectionContent(
                    '1. Vá para a tela de carteiras.\n'
                    '2. Clique no botão de adicionar carteira.\n'
                    '3. Preencha os detalhes da carteira e clique em salvar.\n'
                    '4. Para gerenciar, clique na carteira desejada e escolha a ação desejada.',
                  ),
                  const SizedBox(height: 16),
                  _buildSectionTitle(context, 'Como guardar e recuperar dinheiro da carteira:'),
                  _buildSectionContent(
                    '1. Vá para a tela de carteiras.\n'
                    '2. Selecione a carteira desejada.\n'
                    '3. Escolha a opção de guardar ou recuperar dinheiro e preencha os detalhes.',
                  ),
                  const SizedBox(height: 16),
                  _buildSectionTitle(context, 'Como editar renda e despesa:'),
                  _buildSectionContent(
                    '1. Vá para a tela de rendas ou despesas.\n'
                    '2. Selecione a renda ou despesa que deseja editar.\n'
                    '3. Faça as alterações desejadas e clique em salvar.',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Text(
      content,
      style: const TextStyle(fontSize: 18),
    );
  }
}
