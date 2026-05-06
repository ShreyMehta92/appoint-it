import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../core/services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

/// Manually updated after reloadUser() to notify the router of verification changes.
final emailVerifiedProvider = StateProvider<bool>((ref) {
  return ref.watch(authStateProvider).value?.emailVerified ?? false;
});

final userRoleProvider = FutureProvider.family<String?, String>((ref, uid) async {
  return await ref.read(authServiceProvider).getUserRole(uid);
});
