import 'package:flutter/material.dart';
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
        title: const Text('Cadastrar Carteira'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: 'Nome da Carteira'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _valorController,
              decoration: const InputDecoration(
                labelText: 'Valor (opcional)',
                prefixText: 'R\$ ',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final nome = _nomeController.text;
                final valor = double.tryParse(_valorController.text) ?? 0.0;
                if (nome.isNotEmpty) {
                  economiaController.adicionarCarteira(nome, valor); // Adicionar carteira com valor opcional
                  Navigator.pop(context);
                }
              },
              child: const Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }
}