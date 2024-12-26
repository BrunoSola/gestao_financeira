import 'package:flutter/material.dart';
import 'package:gestao_financeira/controllers/despesa_controller.dart';
import 'package:gestao_financeira/controllers/economia_controller.dart';
import 'package:gestao_financeira/controllers/renda_controller.dart';
import 'package:gestao_financeira/services/auth_service.dart';
import 'package:gestao_financeira/services/firebase_service.dart';
import 'package:gestao_financeira/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    _loadUserIdAndData();
  }

  // Carregar userId e dados financeiros
  Future<void> _loadUserIdAndData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    if (userId != null) {
      await _loadFinancialData(userId);
    } else {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  Future<void> _loadFinancialData(String userId) async {
    final user = AuthService().getCurrentUser();
    if (user != null) {
      final financialData = await FirebaseService().getFinancialData(user.uid);

      final despesaController = Provider.of<DespesaController>(context, listen: false);
      final economiaController = Provider.of<EconomiaController>(context, listen: false);
      final rendaController = Provider.of<RendaController>(context, listen: false);

      if (financialData != null) {
        final totalDespesas = financialData['totalDespesas'] ?? 0.0;
        final totalEconomias = financialData['totalEconomias'] ?? 0.0;
        final totalRendas = financialData['totalRendas'] ?? 0.0;

        despesaController.setTotalDespesas(totalDespesas);
        economiaController.setTotalEconomias(totalEconomias);
        rendaController.setTotalRendas(totalRendas);
      }
    }
  }

  // Logout
  Future<void> _signOut(BuildContext context) async {
    final authService = AuthService();
    await authService.signOut();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);

    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final despesaController = Provider.of<DespesaController>(context);
    final economiaController = Provider.of<EconomiaController>(context);
    final rendaController = Provider.of<RendaController>(context);
    final saldo = rendaController.totalRendas - despesaController.totalDespesa - economiaController.totalEconomias;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gestão Financeira',
          style: TextStyle(
            fontFamily: 'Roboto', // Fonte mais bonita
            fontSize: 24, // Aumentar o tamanho da fonte
            fontWeight: FontWeight.bold,
            color: appBarBackgroundColor, // Cor que combina com o background verde
          ),
          textAlign: TextAlign.center, // Centralizar o texto
        ),
        backgroundColor: Colors.blue,
        centerTitle: true, // Centralizar o título
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await AuthService().signOut();
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.blueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Resumo de Finanças', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 20),
                _buildSummaryCard('Total de Rendas', rendaController.totalRendas, Colors.green, '/tela_renda'),
                _buildSummaryCard('Total de Despesas', despesaController.totalDespesa, Colors.redAccent, '/tela_despesa'),
                _buildSummaryCard('Total de Economias', economiaController.totalEconomias, Colors.green, '/carteiras'),
                _buildSummaryCard('Saldo', saldo, saldo >= 0 ? Colors.green : Colors.red, null),
                const SizedBox(height: 30),
                _buildNavigationButtons(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, double? value, Color color, String? route) {
    final valueToDisplay = value ?? 0.0;

    return GestureDetector(
      onTap: route != null ? () => Navigator.pushNamed(context, route) : null,
      child: Card(
        color: Colors.white.withOpacity(0.9),
        margin: const EdgeInsets.symmetric(vertical: 10),
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16.0),
          title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          trailing: Text(
            valueToDisplay.toStringAsFixed(2),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: color),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButtons(BuildContext context) {
    return Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/cadastro_renda');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            minimumSize: const Size(60, 60),
            shape: const CircleBorder(),
          ),
          child: const Icon(FontAwesomeIcons.plus, color: Colors.white),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/cadastro_despesa');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            minimumSize: const Size(60, 60),
            shape: const CircleBorder(),
          ),
          child: const Icon(FontAwesomeIcons.minus, color: Colors.white),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/cadastro_carteiras');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 211, 197, 0),
            minimumSize: const Size(60, 60),
            shape: const CircleBorder(),
          ),
          child: Image.asset(
            'assets/images/cofrinho.png',  // Caminho para a sua imagem
            width: 35,                      // Largura desejada
            height: 35,                     // Altura desejada
          ),
        ),
      ],
    );
  }
}
