import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gestao_financeira/services/auth_service.dart';
import 'package:gestao_financeira/services/firebase_service.dart';

class DespesaController extends ChangeNotifier {
  double _totalDespesa = 0.0;
  final List<Map<String, dynamic>> _despesas = []; // Lista de despesas.

  double get totalDespesa => _totalDespesa;
  List<Map<String, dynamic>> get despesas => _despesas;

  DespesaController() {
    _loadFinancialData();
  }

  Future<void> _loadFinancialData() async {
    final user = AuthService().getCurrentUser();
    if (user != null) {
      final data = await FirebaseService().getFinancialData(user.uid);
      if (data != null) {
        _totalDespesa = data['totalDespesas'] ?? 0.0;
        notifyListeners();
      }
    }
  }

  void carregarDespesas() async {
    final user = AuthService().getCurrentUser();
    if (user != null) {
      try {
        final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('despesas')
          .get();

        _despesas.clear();
        for (var doc in snapshot.docs) {
          _despesas.add({
            'descricao': doc['descricao'],
            'valor': doc['valor'],
            'tipo': doc['tipo']
          });
        }

        notifyListeners();
      } catch (e) {
        print("Erro ao carregar dados financeiros: $e");
      }
    }
  }

  void adicionarDespesa(String descricao, double valor, String tipo) async {
    final user = AuthService().getCurrentUser();
    if (user != null) {
      final despesa = {'descricao': descricao, 'valor': valor, 'tipo': tipo};
      _despesas.add(despesa);
      _totalDespesa += valor;
      notifyListeners();

      // Salvar despesa no Firestore
      await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('despesas')
        .add(despesa);

      // Atualizar total de despesas
      await FirebaseService().saveFinancialData(
        userId: user.uid,
        totalDespesas: _totalDespesa,
      );
    }
  }

  void removerDespesa(int index) async {
    final user = AuthService().getCurrentUser();
    if (user != null) {
      final despesa = _despesas[index];
      _totalDespesa -= despesa['valor'];
      _despesas.removeAt(index);
      notifyListeners();

      // Remover despesa do Firestore
      final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('despesas')
        .where('descricao', isEqualTo: despesa['descricao'])
        .where('valor', isEqualTo: despesa['valor'])
        .get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }

      // Atualizar total de despesas
      await FirebaseService().saveFinancialData(
        userId: user.uid,
        totalDespesas: _totalDespesa,
      );
    }
  }

  void alterarDespesa(int index, String descricao, double valor, String tipo) async {
    final user = AuthService().getCurrentUser();
    if (user != null) {
      final despesa = _despesas[index];
      _totalDespesa -= despesa['valor'];
      _despesas[index] = {'descricao': descricao, 'valor': valor, 'tipo': tipo};
      _totalDespesa += valor;
      notifyListeners();

      // Atualizar despesa no Firestore
      final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('despesas')
        .where('descricao', isEqualTo: despesa['descricao'])
        .where('valor', isEqualTo: despesa['valor'])
        .get();

      for (var doc in snapshot.docs) {
        await doc.reference.update({'descricao': descricao, 'valor': valor, 'tipo': tipo});
      }

      // Atualizar total de despesas
      await FirebaseService().saveFinancialData(
        userId: user.uid,
        totalDespesas: _totalDespesa,
      );
    }
  }

  // Método para definir o valor total de despesas
  void setTotalDespesas(double valor) {
    _totalDespesa = valor;
    notifyListeners();
  }
}