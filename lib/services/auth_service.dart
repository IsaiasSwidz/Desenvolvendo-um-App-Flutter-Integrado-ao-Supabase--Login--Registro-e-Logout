import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import '../supabase_config.dart';

class AuthService {
  final SupabaseClient _supabase = SupabaseConfig.client;

  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  User? get currentUser => _supabase.auth.currentUser;

  Future<String?> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final AuthResponse response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'name': name,
          'created_at': DateTime.now().toIso8601String(),
        },
      );
      
      if (response.user != null) {
        return null; // Sucesso
      } else {
        return 'Erro ao criar conta';
      }
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'Erro desconhecido: $e';
    }
  }

  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final AuthResponse response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      if (response.user != null) {
        return null; // Sucesso
      } else {
        return 'Erro ao fazer login';
      }
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'Erro desconhecido: $e';
    }
  }

  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      throw Exception('Erro ao fazer logout: $e');
    }
  }

  Future<UserModel?> getCurrentUserProfile() async {
    final user = currentUser;
    if (user == null) return null;

    try {
      final response = await _supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      return UserModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }
}