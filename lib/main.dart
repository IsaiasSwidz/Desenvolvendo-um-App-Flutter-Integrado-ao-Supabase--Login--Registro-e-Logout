import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'supabase_config.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Carrega variáveis de ambiente
  await dotenv.load(fileName: ".env");
  
  // Inicializa o Supabase
  await SupabaseConfig.initialize();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supabase Auth App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final AuthService _authService = AuthService();
  bool _isLoading = true;
  bool _isLoggedIn = false;
  bool _showLogin = true;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
    _setupAuthListener();
  }

  void _checkAuthStatus() {
    final user = _authService.currentUser;
    setState(() {
      _isLoggedIn = user != null;
      _isLoading = false;
    });
  }

  void _setupAuthListener() {
    _authService.authStateChanges.listen((data) {
      final user = data.session?.user;
      setState(() {
        _isLoggedIn = user != null;
      });
    });
  }

  void _toggleScreen() {
    setState(() {
      _showLogin = !_showLogin;
    });
  }

  void _onAuthSuccess() {
    setState(() {
      _isLoggedIn = true;
    });
  }

  void _onLogout() {
    setState(() {
      _isLoggedIn = false;
      _showLogin = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_isLoggedIn) {
      return HomeScreen(onLogout: _onLogout);
    }

    if (_showLogin) {
      return LoginScreen(
        onToggleScreen: _toggleScreen,
        onLoginSuccess: _onAuthSuccess,
      );
    } else {
      return RegisterScreen(
        onToggleScreen: _toggleScreen,
        onRegisterSuccess: _onAuthSuccess,
      );
    }
  }
}