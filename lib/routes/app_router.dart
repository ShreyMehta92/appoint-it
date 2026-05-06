import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/booking/dashboard_screen.dart';
import '../features/booking/booking_screen.dart';
import '../features/queue/queue_status_screen.dart';
import '../features/admin/admin_dashboard_screen.dart';
import '../features/search/search_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/register_screen.dart';
import '../features/auth/verify_email_screen.dart';
import '../providers/auth_providers.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  final isEmailVerified = ref.watch(emailVerifiedProvider);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: _AuthRefreshListenable(ref),
    redirect: (context, state) {
      final isLoggedIn = authState.value != null;
      final isEmailVerified = ref.read(emailVerifiedProvider);
      final loc = state.matchedLocation;

      final isAuthRoute = loc == '/login' || loc == '/register';
      final isVerifyRoute = loc == '/verify-email';

      // Not logged in → go to login
      if (!isLoggedIn) {
        return isAuthRoute ? null : '/login';
      }

      // Logged in but email not verified → go to verify screen
      if (!isEmailVerified) {
        return isVerifyRoute ? null : '/verify-email';
      }

      // Logged in + verified + on auth screen → go to dashboard
      if (isAuthRoute || isVerifyRoute) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/verify-email',
        builder: (context, state) => const VerifyEmailScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/booking',
        builder: (context, state) => const BookingScreen(),
      ),
      GoRoute(
        path: '/queue',
        builder: (context, state) => const QueueStatusScreen(),
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) => const SearchScreen(),
      ),
    ],
  );
});

class _AuthRefreshListenable extends ChangeNotifier {
  _AuthRefreshListenable(Ref ref) {
    ref.listen(authStateProvider, (previous, next) {
      notifyListeners();
    });
    ref.listen(emailVerifiedProvider, (previous, next) {
      notifyListeners();
    });
  }
}
