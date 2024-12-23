import 'package:flutter/material.dart';

class FinanceController extends ChangeNotifier {
  double _saldo = 0.0;

  // Obter o saldo atual
  double get saldo => _saldo;

  // Calcular o saldo com base nas rendas, gastos e economias
  void calculateSaldo({required double totalRendas, required double totalDespesas, required double totalEconomias}) 
    {
    // Calculando o saldo: rendas - gastos - economias (economias não devem ser usadas)
    _saldo = totalRendas - totalDespesas - totalEconomias;
    notifyListeners();  // Notifica os listeners para atualizar o UI
  }

  // Atualizar o saldo com base nas mudanças nos valores de renda, gasto e economia
  void updateSaldo({
    required double totalRendas,
    required double totalDespesas,
    required double totalEconomias,
  }) {
    _saldo = totalRendas - totalDespesas - totalEconomias;
    notifyListeners();  // Notifica os listeners para atualizar o UI
  }
}


