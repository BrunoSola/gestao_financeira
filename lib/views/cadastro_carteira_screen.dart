import 'package:flutter/material.dart';
import 'package:gestao_financeira/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:gestao_financeira/controllers/economia_controller.dart';

class CadastroCarteiraScreen extends StatelessWidget {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();

  CadastroCarteiraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final economiaController = Provider.of<EconomiaController>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Carteira',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Cor do texto do AppBar
          ),
        ),
        backgroundColor: appBarBackgroundColor,
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
                    'Cadastrar Carteira',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _nomeController,
                    decoration: InputDecoration(
                      labelText: 'Nome da Carteira',
                      labelStyle: const TextStyle(
                        color: Colors.blue, // Cor do texto do rótulo
                        fontWeight: FontWeight.bold,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF5F5F5), // Cor de fundo do campo
                      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.blue,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.blue,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _valorController,
                    decoration: InputDecoration(
                      labelText: 'Valor (opcional)',
                      prefixText: 'R\$ ',
                      labelStyle: const TextStyle(
                        color: Colors.blue, // Cor do texto do rótulo
                        fontWeight: FontWeight.bold,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF5F5F5), // Cor de fundo do campo
                      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.blue,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.blue,
                          width: 2.0,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      final nome = _nomeController.text;
                      final valor = double.tryParse(_valorController.text) ?? 0.0;
                      if (nome.isNotEmpty) {
                        economiaController.adicionarCarteira(nome, valor);
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: const Text('Cadastrar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
