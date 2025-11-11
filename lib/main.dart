import 'package:flutter/material.dart';
import 'package:flutter_application_3/screens/home_screen.dart';
import 'package:flutter_application_3/screens/login_screen.dart';
import 'package:flutter_application_3/screens/register_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://xdenlzphtecnjuqrmgvz.supabase.co',
  );
  
  const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhkZW5senBodGVjbmp1cXJtZ3Z6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjI4OTg5MzgsImV4cCI6MjA3ODQ3NDkzOH0.q7pMBAI7tji5zarydMPHCzOClJccHbO1WG6G7nwk6Dk',
  );

  try {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
    print('✅ Supabase inicializado com sucesso!');
  } catch (e) {
    print('❌ Erro ao inicializar Supabase: $e');
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Supabase',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
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
  final SupabaseClient _supabase = Supabase.instance.client;
  bool _isLoading = true;
  bool _isLoggedIn = false;
  bool _showLogin = true;

  @override
  void initState() {
    super.initState();
    _checkAuth();
    _setupAuthListener();
  }

  Future<void> _checkAuth() async {
    final session = _supabase.auth.currentSession;
    setState(() {
      _isLoggedIn = session != null;
      _isLoading = false;
    });
  }

  void _setupAuthListener() {
    _supabase.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      setState(() {
        _isLoggedIn = session != null;
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
        body: Center(child: CircularProgressIndicator()),
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