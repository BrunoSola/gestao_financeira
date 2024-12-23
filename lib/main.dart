import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gestao_financeira/views/cadastro_carteira_screen.dart' as cadastro_carteira;
import 'package:gestao_financeira/views/cadastro_renda_screen.dart';
import 'package:gestao_financeira/views/dashboard_screen.dart';
import 'package:gestao_financeira/views/despesa_screen.dart';
import 'package:gestao_financeira/views/renda_screen.dart';
import 'package:provider/provider.dart';
import 'package:gestao_financeira/controllers/despesa_controller.dart';
import 'package:gestao_financeira/controllers/economia_controller.dart';
import 'package:gestao_financeira/controllers/renda_controller.dart';
import 'package:gestao_financeira/controllers/finance_controller.dart'; // Importando o FinanceController
import 'package:gestao_financeira/views/authCheck.dart';
import 'package:gestao_financeira/views/cadastro_economia_screen.dart';
import 'package:gestao_financeira/views/cadastro_despesa_screen.dart';
import 'package:gestao_financeira/views/carteiras_screen.dart'; // Importando CarteirasScreen
import 'package:gestao_financeira/views/login_screen.dart';
import 'package:gestao_financeira/views/sign_in_screen.dart';
import 'package:gestao_financeira/views/sobre_screen.dart';
import 'package:gestao_financeira/views/help_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Certifique-se de habilitar o provedor de login no Firebase Console
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DespesaController()),
        ChangeNotifierProvider(create: (_) => EconomiaController()),
        ChangeNotifierProvider(create: (_) => RendaController()),
        ChangeNotifierProvider(create: (_) => FinanceController()), // Não criar novos controladores aqui
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey, // Adicionar a chave do navegador aqui
        title: 'Gestão Financeira',
        initialRoute: '/',
        routes: {
          '/': (context) => const AuthCheck(),
          '/dashboard': (context) => const DashboardScreen(),
          '/cadastro_despesa': (context) => const CadastroDespesaScreen(),
          '/cadastro_economia': (context) {
            final carteira = Provider.of<EconomiaController>(context, listen: false).carteiras.isNotEmpty
                ? Provider.of<EconomiaController>(context, listen: false).carteiras.first
                : {'nome': '', 'valor': 0.0}; // Garantir que 'carteira' seja do tipo Map<String, dynamic>
            return CadastroEconomiaScreen(carteira: carteira);
          }, // Adicionar o argumento obrigatório 'carteira'
          '/cadastro_carteiras': (context) => cadastro_carteira.CadastroCarteiraScreen(),
          '/cadastro_renda': (context) => const CadastroRendaScreen(),
          '/tela_renda': (context) => const TelaRenda(),
          '/tela_despesa': (context) => const TelaDespesas(),
          '/carteiras': (context) => const CarteirasScreen(), // Adicionar a rota para CarteirasScreen
          '/login': (context) => const LoginScreen(),
          '/sign_in': (context) => const SignInScreen(),
          '/sobre': (context) => const SobreScreen(),
          '/help': (context) => const HelpScreen(),
        },
      ),
    );
  }
}
