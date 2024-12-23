import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {

  Future<void> saveFinancialData({
      String? userId,
      double? totalRendas,
      double? totalDespesas,
      double? totalEconomias,
    }) async {
      try {
        DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();
        Map<String, dynamic> existingData = snapshot.data() as Map<String, dynamic>? ?? {};

        Map<String, double?> dataToUpdate = {
          'totalRendas': totalRendas ?? existingData['totalRendas'],
          'totalDespesas': totalDespesas ?? existingData['totalDespesas'],
          'totalEconomias': totalEconomias ?? existingData['totalEconomias'],
        };

        await FirebaseFirestore.instance.collection('users').doc(userId).set(dataToUpdate, SetOptions(merge: true));
        print("Dados salvos com sucesso!");
      } catch (e) {
        print("Erro ao salvar dados financeiros: $e");
      }
  } 

  // Método para recuperar dados financeiros do Firestore
  Future<Map<String, double>?> getFinancialData(String userId) async {
    try {
      final DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (snapshot.exists) {
        return {
          'totalDespesas': snapshot['totalDespesas'] ?? 0.0,
          'totalEconomias': snapshot['totalEconomias'] ?? 0.0,
          'totalRendas': snapshot['totalRendas'] ?? 0.0,
        };
      } else {
        return null;
      }
    } catch (e) {
      print("Erro ao recuperar dados financeiros: $e");
      return null;
    }
  }
}