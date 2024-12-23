import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gestao_financeira/controllers/renda_controller.dart';

class CadastroRendaScreen extends StatefulWidget {
  const CadastroRendaScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CadastroRendaScreenState createState() => _CadastroRendaScreenState();
}

class _CadastroRendaScreenState extends State<CadastroRendaScreen> {
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();

  void _adicionarRenda(BuildContext context) {
    final descricao = _descricaoController.text;
    final valor = double.tryParse(_valorController.text) ?? 0.0;

    if (descricao.isNotEmpty && valor > 0) {
      // Acessa o RendaController através do Provider
      final rendaController = Provider.of<RendaController>(context, listen: false);
      // Passando ambos os parâmetros: descrição e valor
      rendaController.adicionarRenda(descricao, valor);

      // Limpa os campos e retorna à tela anterior
      _descricaoController.clear();
      _valorController.clear();
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos corretamente!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Renda'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _descricaoController,
              decoration: const InputDecoration(
                labelText: 'Descrição da Renda',
              ),
            ),
            TextField(
              controller: _valorController,
              decoration: const InputDecoration(
                labelText: 'Valor da Renda',
                prefixText: 'R\$ ',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _adicionarRenda(context),
              child: const Text('Adicionar Renda'),
            ),
          ],
        ),
      ),
    );
  }
}
