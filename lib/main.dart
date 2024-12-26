import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gestao_financeira/services/auth_service.dart';
import 'package:gestao_financeira/utils/constants.dart';
import 'package:gestao_financeira/views/cadastro_carteira_screen.dart' as cadastro_carteira;
import 'package:gestao_financeira/views/cadastro_renda_screen.dart';
import 'package:gestao_financeira/views/dashboard_screen.dart';
import 'package:gestao_financeira/views/despesa_screen.dart';
import 'package:gestao_financeira/views/onboarding_screen.dart';
import 'package:gestao_financeira/views/renda_screen.dart';
import 'package:provider/provider.dart';
import 'package:gestao_financeira/controllers/despesa_controller.dart';
import 'package:gestao_financeira/controllers/economia_controller.dart';
import 'package:gestao_financeira/controllers/renda_controller.dart';
import 'package:gestao_financeira/controllers/finance_controller.dart';
import 'package:gestao_financeira/views/cadastro_economia_screen.dart';
import 'package:gestao_financeira/views/cadastro_despesa_screen.dart';
import 'package:gestao_financeira/views/carteiras_screen.dart';
import 'package:gestao_financeira/views/login_screen.dart';
import 'package:gestao_financeira/views/sign_in_screen.dart';
import 'package:gestao_financeira/views/sobre_screen.dart';
import 'package:gestao_financeira/views/help_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        ChangeNotifierProvider(create: (_) => FinanceController()),
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Gestão Financeira',
        theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: appBarBackgroundColor, // Cor padrão das AppBars
        ),
        primarySwatch: Colors.deepPurple, // Define uma paleta de cores geral
      ),
        initialRoute: '/',
        routes: {
          '/': (context) => OnboardingScreen(),
          '/dashboard': (context) => const DashboardScreen(),
          '/cadastro_despesa': (context) => const CadastroDespesaScreen(),
          '/cadastro_economia': (context) {
            final carteira = Provider.of<EconomiaController>(context).carteiras.isNotEmpty
                ? Provider.of<EconomiaController>(context).carteiras.first
                : {'nome': '', 'valor': 0.0}; // Valor padrão
            return CadastroEconomiaScreen(carteira: carteira);
          },
          '/cadastro_carteiras': (context) => cadastro_carteira.CadastroCarteiraScreen(),
          '/cadastro_renda': (context) => const CadastroRendaScreen(),
          '/tela_renda': (context) => const TelaRenda(),
          '/tela_despesa': (context) => const TelaDespesas(),
          '/carteiras': (context) => const CarteirasScreen(),
          '/login': (context) => const LoginScreen(),
          '/sign_in': (context) => const SignInScreen(),
          '/sobre': (context) => const SobreScreen(),
          '/help': (context) => const HelpScreen(),
        },
      ),
    );
  }
}
