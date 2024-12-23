import 'package:flutter/material.dart';

class RelatorioScreen extends StatelessWidget {
  const RelatorioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Relatório de Finanças')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Exibir gráficos e relatórios de finanças aqui
            const Text('Relatório de Gasto vs Economia'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Funcionalidade para visualizar gráficos ou detalhes
              },
              child: const Text('Ver Gráficos'),
            ),
          ],
        ),
      ),
    );
  }
}
