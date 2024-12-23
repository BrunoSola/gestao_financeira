import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gestao_financeira/controllers/economia_controller.dart';

class TelaEconomia extends StatelessWidget {
  const TelaEconomia({super.key});

  @override
  Widget build(BuildContext context) {
    final economiaController = Provider.of<EconomiaController>(context, listen: true);

    // Recuperar carteiras do banco de dados
    economiaController.carregarCarteiras();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Economias'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/cadastro_carteira');
            },
            icon: const Icon(Icons.add),
            tooltip: 'Nova Carteira',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: economiaController.carteiras.isEmpty
            ? const Center(
                child: Text(
                  'Nenhuma carteira cadastrada.',
                  style: TextStyle(fontSize: 18),
                ),
              )
            : ListView.builder(
                itemCount: economiaController.carteiras.length,
                itemBuilder: (context, index) {
                  final carteira = economiaController.carteiras[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(carteira['nome']),
                      subtitle: Text('Valor: R\$ ${carteira['valor'].toStringAsFixed(2)}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/cadastro_carteira',
                                arguments: carteira,
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              economiaController.removerCarteira(index);
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/detalhes_carteira',
                          arguments: carteira,
                        );
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
