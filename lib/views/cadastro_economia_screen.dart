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
        title: Text('Carteira: ${widget.carteira['nome']}',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Cor do texto do AppBar
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Container(
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
                  Text(
                    'Valor Atual: R\$ ${widget.carteira['valor'].toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _valorController,
                    decoration: InputDecoration(
                      labelText: 'Valor',
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => _guardarValor(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                        child: const Text('Guardar'),
                      ),
                      ElevatedButton(
                        onPressed: () => _recuperarValor(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          textStyle: const TextStyle(fontSize: 18),
                        ),
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
