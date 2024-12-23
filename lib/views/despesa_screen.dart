import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gestao_financeira/controllers/despesa_controller.dart';

class TelaDespesas extends StatelessWidget {
  const TelaDespesas({super.key});

  @override
  Widget build(BuildContext context) {
    final despesaController = Provider.of<DespesaController>(context, listen: true);

    // Recuperar despesas do banco de dados
    despesaController.carregarDespesas();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Despesas'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/cadastro_despesa');
            },
            icon: const Icon(Icons.add),
            tooltip: 'Nova Despesa',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: despesaController.despesas.isEmpty
            ? const Center(
                child: Text(
                  'Nenhuma despesa cadastrada.',
                  style: TextStyle(fontSize: 18),
                ),
              )
            : ListView.builder(
                itemCount: despesaController.despesas.length,
                itemBuilder: (context, index) {
                  final despesa = despesaController.despesas[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(despesa['descricao']),
                      subtitle: Text('Valor: R\$ ${despesa['valor'].toStringAsFixed(2)}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/cadastro_despesa',
                                arguments: despesa,
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              despesaController.removerDespesa(index);
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
