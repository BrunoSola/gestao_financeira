import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gestao_financeira/controllers/economia_controller.dart';

class DetalhesCarteiraScreen extends StatelessWidget {
  final Map<String, dynamic> carteira;

  const DetalhesCarteiraScreen({super.key, required this.carteira});

  @override
  Widget build(BuildContext context) {
    final economiaController = Provider.of<EconomiaController>(context, listen: true);
    final TextEditingController valorController = TextEditingController();

    void reservarValor() {
      final valor = double.tryParse(valorController.text) ?? 0.0;
      if (valor > 0) {
        economiaController.reservarValor(economiaController.carteiras.indexOf(carteira), valor);
        valorController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Informe um valor válido!')),
        );
      }
    }

    void showErrorDialog(BuildContext context, String message, double valorAtual) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erro'),
            content: Text('$message\nValor atual disponível: R\$ ${valorAtual.toStringAsFixed(2)}'),
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

    void recuperarValor() {
      final valor = double.tryParse(valorController.text) ?? 0.0;
      if (valor > 0) {
        try {
          economiaController.recuperarValor(economiaController.carteiras.indexOf(carteira), valor);
          valorController.clear();
        } catch (e) {
          showErrorDialog(context, e.toString(), carteira['valor']);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Informe um valor válido!')),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes da Carteira: ${carteira['nome']}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Valor Atual: R\$ ${carteira['valor'].toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: valorController,
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
                  onPressed: reservarValor,
                  child: const Text('Reservar'),
                ),
                ElevatedButton(
                  onPressed: recuperarValor,
                  child: const Text('Recuperar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
