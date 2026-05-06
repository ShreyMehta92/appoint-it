import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/authentication/splash_screen.dart';
import '../features/booking/dashboard_screen.dart';
import '../features/booking/booking_screen.dart';
import '../features/queue/queue_status_screen.dart';
import '../features/admin/admin_dashboard_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/dashboard',
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
    ],
  );
});
