import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gestao_financeira/controllers/economia_controller.dart';
import 'package:gestao_financeira/views/cadastro_economia_screen.dart';

class TelaEconomia extends StatelessWidget {
  const TelaEconomia({super.key});

  @override
  Widget build(BuildContext context) {
    final economiaController = Provider.of<EconomiaController>(context, listen: true);

    // Recuperar carteiras do banco de dados
    economiaController.carregarCarteiras();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Economias',
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
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CadastroEconomiaScreen(carteira: carteira);
                                  },
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
      ),
    );
  }
}
