import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gestao_financeira/controllers/renda_controller.dart';

class TelaRenda extends StatelessWidget {
  const TelaRenda({super.key});

  @override
  Widget build(BuildContext context) {
    final rendaController = Provider.of<RendaController>(context, listen: true);

    // Recuperar rendas do banco de dados
    rendaController.carregarRendas();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rendas'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/cadastro_renda');
            },
            icon: const Icon(Icons.add),
            tooltip: 'Nova Renda',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: rendaController.rendas.isEmpty
            ? const Center(
                child: Text(
                  'Nenhuma renda cadastrada.',
                  style: TextStyle(fontSize: 18),
                ),
              )
            : ListView.builder(
                itemCount: rendaController.rendas.length,
                itemBuilder: (context, index) {
                  final renda = rendaController.rendas[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(renda['descricao']),
                      subtitle: Text('Valor: R\$ ${renda['valor'].toStringAsFixed(2)}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/cadastro_renda',
                                arguments: renda,
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              rendaController.removerRenda(index);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}