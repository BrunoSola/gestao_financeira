import 'package:flutter/material.dart';
import 'package:gestao_financeira/views/cadastro_economia_screen.dart';
import 'package:provider/provider.dart';
import 'package:gestao_financeira/controllers/economia_controller.dart';

class CarteirasScreen extends StatelessWidget {
  const CarteirasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final economiaController = Provider.of<EconomiaController>(context, listen: true);

    // Recuperar carteiras do banco de dados
    economiaController.carregarCarteiras();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carteiras de Economia'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CadastroCarteiraScreen(),
                ),
              );
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
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CadastroEconomiaScreen(carteira: carteira),
                          ),
                        );
                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          if (carteira['valor'] == 0.0) {
                            _confirmDelete(context, economiaController, index);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('A carteira deve ter valor 0 para ser excluída.')),
                            );
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, EconomiaController economiaController, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: const Text('Tem certeza que deseja excluir esta carteira?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                economiaController.removerCarteira(index);
                Navigator.of(context).pop();
              },
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  }
}

class CadastroCarteiraScreen extends StatelessWidget {
  final TextEditingController _nomeController = TextEditingController();

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
            ElevatedButton(
              onPressed: () {
                final nome = _nomeController.text;
                if (nome.isNotEmpty) {
                  economiaController.adicionarCarteira(nome, 0.0); // Adicionar carteira sem valor inicialmente
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
