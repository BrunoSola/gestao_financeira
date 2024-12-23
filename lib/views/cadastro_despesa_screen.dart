import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gestao_financeira/controllers/despesa_controller.dart';

class CadastroDespesaScreen extends StatefulWidget {
  const CadastroDespesaScreen({super.key});

  @override
  State<CadastroDespesaScreen> createState() => _CadastroDespesaScreenState();
}

class _CadastroDespesaScreenState extends State<CadastroDespesaScreen> {
  final _descricaoController = TextEditingController();
  final _valorController = TextEditingController();
  String? _tipoSelecionado;

  final List<String> _tiposDespesas = ['Fixa', 'Variável'];

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _descricaoController.dispose();
    _valorController.dispose();
    super.dispose();
  }

  void _salvarDespesa() {
    if (_formKey.currentState!.validate()) {
      final descricao = _descricaoController.text.trim();
      final valor = double.parse(_valorController.text.trim());
      final tipo = _tipoSelecionado ?? 'Fixa';

      final despesaController = Provider.of<DespesaController>(context, listen: false);

      // Adicionando despesa no controller
      despesaController.adicionarDespesa(descricao, valor, tipo);

      // Feedback e navegação
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Despesa adicionada com sucesso!')),
      );

      Navigator.pop(context); // Fecha a tela após salvar
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Despesa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'A descrição é obrigatória.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _valorController,
                decoration: const InputDecoration(
                  labelText: 'Valor',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O valor é obrigatório.';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Informe um valor numérico válido.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Tipo',
                  border: OutlineInputBorder(),
                ),
                value: _tipoSelecionado,
                items: _tiposDespesas.map((tipo) {
                  return DropdownMenuItem(
                    value: tipo,
                    child: Text(tipo),
                  );
                }).toList(),
                onChanged: (tipo) {
                  setState(() {
                    _tipoSelecionado = tipo;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Selecione o tipo de despesa.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24.0),
              Center(
                child: ElevatedButton(
                  onPressed: _salvarDespesa,
                  child: const Text('Salvar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
