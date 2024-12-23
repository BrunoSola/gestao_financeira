import 'package:flutter/material.dart';
import 'package:gestao_financeira/controllers/renda_controller.dart';
import 'package:provider/provider.dart';

class PreCadastroScreen extends StatefulWidget {
  const PreCadastroScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PreCadastroScreenState createState() => _PreCadastroScreenState();
}

class _PreCadastroScreenState extends State<PreCadastroScreen> {
  final TextEditingController _rendaController = TextEditingController();
  bool _duplicarRenda = false;

  @override
  void dispose() {
    _rendaController.dispose();
    super.dispose();
  }

  void _adicionarRenda(BuildContext context) {
    const descricao = "Renda Inicial"; // Exemplo de descrição, você pode permitir o usuário informar isso também
    final renda = double.tryParse(_rendaController.text.trim());

    if (renda == null || renda <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe um valor válido para a renda.')),
      );
      return;
    }

    final rendaController = Provider.of<RendaController>(context, listen: false);
    rendaController.adicionarRenda(descricao, renda);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Renda adicionada com sucesso!')),
    );

    setState(() {
      _rendaController.clear();
    });
  }


  void _concluirPreCadastro(BuildContext context) {
    // Lógica para salvar configurações do pré-cadastro, se necessário.
    Navigator.pushReplacementNamed(context, '/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pré-Cadastro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Informe sua Renda Mensal (opcional)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _rendaController,
                decoration: const InputDecoration(
                  labelText: 'Renda Mensal',
                  prefixText: 'R\$ ',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _adicionarRenda(context),
                child: const Text('Adicionar Renda'),
              ),
              const SizedBox(height: 24),
              const Text(
                'Deseja duplicar suas rendas todo mês?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  ChoiceChip(
                    label: const Text('Sim'),
                    selected: _duplicarRenda,
                    onSelected: (bool selected) {
                      setState(() {
                        _duplicarRenda = selected;
                      });
                    },
                  ),
                  const SizedBox(width: 10),
                  ChoiceChip(
                    label: const Text('Não'),
                    selected: !_duplicarRenda,
                    onSelected: (bool selected) {
                      setState(() {
                        _duplicarRenda = !selected;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => _concluirPreCadastro(context),
                child: const Text('Concluir Pré-Cadastro'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
