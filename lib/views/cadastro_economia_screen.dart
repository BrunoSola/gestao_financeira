import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gestao_financeira/controllers/economia_controller.dart';

class CadastroEconomiaScreen extends StatefulWidget {
  final Map<String, dynamic> carteira;

  const CadastroEconomiaScreen({super.key, required this.carteira});

  @override
  _CadastroEconomiaScreenState createState() => _CadastroEconomiaScreenState();
}

class _CadastroEconomiaScreenState extends State<CadastroEconomiaScreen> {
  final TextEditingController _valorController = TextEditingController();

  void _guardarValor(BuildContext context) {
    final valor = double.tryParse(_valorController.text) ?? 0.0;

    if (valor > 0) {
      final economiaController = Provider.of<EconomiaController>(context, listen: false);
      final index = economiaController.carteiras.indexWhere((c) => c['id'] == widget.carteira['id']);
      if (index != -1) {
        economiaController.reservarValor(index, valor);

        _valorController.clear();
        Navigator.pop(context);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe um valor válido!')),
      );
    }
  }

  void _recuperarValor(BuildContext context) {
    final valor = double.tryParse(_valorController.text) ?? 0.0;

    if (valor > 0) {
      final economiaController = Provider.of<EconomiaController>(context, listen: false);
      final index = economiaController.carteiras.indexWhere((c) => c['id'] == widget.carteira['id']);
      if (index != -1) {
        final error = economiaController.recuperarValor(index, valor);
        if (error == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Valor recuperado com sucesso!')),
          );
          _valorController.clear();
          Navigator.pop(context);
        } else {
          _showErrorDialog(context, error);
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe um valor válido!')),
      );
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Erro'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carteira: ${widget.carteira['nome']}'),
        backgroundColor: Colors.teal,
      ),
      body: Container(
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
                  Text(
                    'Valor Atual: R\$ ${widget.carteira['valor'].toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _valorController,
                    decoration: const InputDecoration(
                      labelText: 'Valor',
                      prefixText: 'R\$ ',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => _guardarValor(context),
                        child: const Text('Guardar'),
                      ),
                      ElevatedButton(
                        onPressed: () => _recuperarValor(context),
                        child: const Text('Recuperar'),
                      ),
                    ],
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
