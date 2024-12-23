import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gestao_financeira/services/auth_service.dart';
import 'package:gestao_financeira/services/firebase_service.dart';

class RendaController extends ChangeNotifier {
  double _totalRendas = 0.0;
  final List<Map<String, dynamic>> _rendas = []; // Lista de rendas.

  double get totalRendas => _totalRendas;
  List<Map<String, dynamic>> get rendas => _rendas;

  RendaController() {
    _loadFinancialData();
  }

  Future<void> _loadFinancialData() async {
    final user = AuthService().getCurrentUser();
    if (user != null) {
      final data = await FirebaseService().getFinancialData(user.uid);
      if (data != null) {
        _totalRendas = data['totalRendas'] ?? 0.0;
        notifyListeners();
      }
    }
  }

  void carregarRendas() async {
    final user = AuthService().getCurrentUser();
    if (user != null) {
      try {
        final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('rendas')
          .get();

        _rendas.clear();
        for (var doc in snapshot.docs) {
          _rendas.add({
            'descricao': doc['descricao'],
            'valor': doc['valor']
          });
        }

        notifyListeners();
      } catch (e) {
        print("Erro ao carregar dados financeiros: $e");
      }
    }
  }

  void adicionarRenda(String descricao, double valor) async {
    final user = AuthService().getCurrentUser();
    if (user != null) {
      final renda = {'descricao': descricao, 'valor': valor};
      _rendas.add(renda);
      _totalRendas += valor;
      notifyListeners();

      // Salvar renda no Firestore
      await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('rendas')
        .add(renda);

      // Atualizar total de rendas
      await FirebaseService().saveFinancialData(
        userId: user.uid,
        totalRendas: _totalRendas,
      );
    }
  }

  void removerRenda(int index) async {
    final user = AuthService().getCurrentUser();
    if (user != null) {
      final renda = _rendas[index];
      _totalRendas -= renda['valor'];
      _rendas.removeAt(index);
      notifyListeners();

      // Remover renda do Firestore
      final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('rendas')
        .where('descricao', isEqualTo: renda['descricao'])
        .where('valor', isEqualTo: renda['valor'])
        .get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }

      // Atualizar total de rendas
      await FirebaseService().saveFinancialData(
        userId: user.uid,
        totalRendas: _totalRendas,
      );
    }
  }

  void alterarRenda(int index, String descricao, double valor) async {
    final user = AuthService().getCurrentUser();
    if (user != null) {
      final renda = _rendas[index];
      _totalRendas -= renda['valor'];
      _rendas[index] = {'descricao': descricao, 'valor': valor};
      _totalRendas += valor;
      notifyListeners();

      // Atualizar renda no Firestore
      final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('rendas')
        .where('descricao', isEqualTo: renda['descricao'])
        .where('valor', isEqualTo: renda['valor'])
        .get();

      for (var doc in snapshot.docs) {
        await doc.reference.update({'descricao': descricao, 'valor': valor});
      }

      // Atualizar total de rendas
      await FirebaseService().saveFinancialData(
        userId: user.uid,
        totalRendas: _totalRendas,
      );
    }
  }

  // Método para definir o valor total de rendas
  void setTotalRendas(double valor) {
    _totalRendas = valor;
    notifyListeners();
  }
}
