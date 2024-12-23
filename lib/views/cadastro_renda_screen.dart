import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gestao_financeira/controllers/renda_controller.dart';

class CadastroRendaScreen extends StatefulWidget {
  const CadastroRendaScreen({super.key});

  @override
  _CadastroRendaScreenState createState() => _CadastroRendaScreenState();
}

class _CadastroRendaScreenState extends State<CadastroRendaScreen> {
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final renda = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (renda != null) {
      _descricaoController.text = renda['descricao'];
      _valorController.text = renda['valor'].toString();
    }
  }

  void _adicionarRenda(BuildContext context) {
    final descricao = _descricaoController.text;
    final valor = double.tryParse(_valorController.text) ?? 0.0;

    if (descricao.isNotEmpty && valor > 0) {
      final rendaController = Provider.of<RendaController>(context, listen: false);
      rendaController.adicionarRenda(descricao, valor);

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
        title: const Text('Adicionar Renda',
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
          ),
        ),
      ),
    );
  }
}
