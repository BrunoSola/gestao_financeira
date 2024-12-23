import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gestao_financeira/services/auth_service.dart';
import 'package:gestao_financeira/services/firebase_service.dart';

class EconomiaController extends ChangeNotifier {
  double _totalEconomias = 0.0;
  final List<Map<String, dynamic>> _carteiras = []; // Lista de carteiras de economia.

  double get totalEconomias => _totalEconomias;
  List<Map<String, dynamic>> get carteiras => _carteiras;

  EconomiaController() {
    _loadFinancialData();
  }

  Future<void> _loadFinancialData() async {
    final user = AuthService().getCurrentUser();
    if (user != null) {
      final data = await FirebaseService().getFinancialData(user.uid);
      if (data != null) {
        _totalEconomias = data['totalEconomias'] ?? 0.0;
        notifyListeners();
      }
    }
  }

  void carregarCarteiras() async {
    final user = AuthService().getCurrentUser();
    if (user != null) {
      try {
        final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('carteiras')
          .get();

        _carteiras.clear();
        for (var doc in snapshot.docs) {
          _carteiras.add({
            'id': doc.id,
            'nome': doc['nome'],
            'valor': doc['valor']
          });
        }

        notifyListeners();
      } catch (e) {
        print("Erro ao carregar dados financeiros: $e");
      }
    }
  }

  void adicionarCarteira(String nome, double valor) async {
    final user = AuthService().getCurrentUser();
    if (user != null) {
      final carteira = {'nome': nome, 'valor': valor};
      final docRef = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('carteiras')
        .add(carteira);

      _carteiras.add({
        'id': docRef.id,
        'nome': nome,
        'valor': valor
      });
      _totalEconomias += valor;
      notifyListeners();

      // Atualizar total de economias
      await FirebaseService().saveFinancialData(
        userId: user.uid,
        totalEconomias: _totalEconomias,
      );
    }
  }

  void removerCarteira(int index) async {
    final user = AuthService().getCurrentUser();
    if (user != null) {
      final carteira = _carteiras[index];
      _totalEconomias -= carteira['valor'];
      _carteiras.removeAt(index);
      notifyListeners();

      // Remover carteira do Firestore
      await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('carteiras')
        .doc(carteira['id'])
        .delete();

      // Atualizar total de economias
      await FirebaseService().saveFinancialData(
        userId: user.uid,
        totalEconomias: _totalEconomias,
      );
    }
  }

  void alterarCarteira(int index, String nome, double valor) async {
    final user = AuthService().getCurrentUser();
    if (user != null) {
      final carteira = _carteiras[index];
      _totalEconomias -= carteira['valor'];
      _carteiras[index] = {'id': carteira['id'], 'nome': nome, 'valor': valor};
      _totalEconomias += valor;
      notifyListeners();

      // Atualizar carteira no Firestore
      await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('carteiras')
        .doc(carteira['id'])
        .update({'nome': nome, 'valor': valor});

      // Atualizar total de economias
      await FirebaseService().saveFinancialData(
        userId: user.uid,
        totalEconomias: _totalEconomias,
      );
    }
  }

  void reservarValor(int index, double valor) async {
    final user = AuthService().getCurrentUser();
    if (user != null) {
      _carteiras[index]['valor'] += valor;
      _totalEconomias += valor;
      notifyListeners();

      // Atualizar carteira no Firestore
      await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('carteiras')
        .doc(_carteiras[index]['id'])
        .update({'valor': _carteiras[index]['valor']});

      // Atualizar total de economias
      await FirebaseService().saveFinancialData(
        userId: user.uid,
        totalEconomias: _totalEconomias,
      );
    }
  }

  String? recuperarValor(int index, double valor) {
    if (_carteiras[index]['valor'] >= valor) {
      _carteiras[index]['valor'] -= valor;
      _totalEconomias -= valor;
      notifyListeners();

      // Atualizar Firestore
      FirebaseFirestore.instance
          .collection('users')
          .doc(AuthService().getCurrentUser()?.uid)
          .collection('carteiras')
          .doc(_carteiras[index]['id'])
          .update({'valor': _carteiras[index]['valor']});

      // Atualizar total de economias no Firestore
      FirebaseService().saveFinancialData(
        userId: AuthService().getCurrentUser()?.uid ?? '',
        totalEconomias: _totalEconomias,
      );

      return null; // Sucesso
    } else {
      return 'Saldo insuficiente! Você só possui R\$ ${_carteiras[index]['valor'].toStringAsFixed(2)} disponível.';
    }
  }


  // Método para definir o valor total de economias
  void setTotalEconomias(double valor) {
    _totalEconomias = valor;
    notifyListeners();
  }
}
