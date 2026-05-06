import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../data/models/queue_token_model.dart';
import '../../providers/data_providers.dart';
import '../../providers/auth_providers.dart';
import '../queue/queue_service.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueBox = ref.watch(queueTokenBoxProvider);
    final queueService = ref.watch(queueServiceProvider);
    final user = ref.watch(authStateProvider).value;
    final roleAsync = user != null ? ref.watch(userRoleProvider(user.uid)) : const AsyncValue<String?>.data(null);

    if (roleAsync.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (roleAsync.value != 'admin') {
      return Scaffold(
        appBar: AppBar(title: const Text('Access Denied')),
        body: const Center(child: Text('You do not have permission to access the admin area.')),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        title: const Text('Admin Dashboard', style: TextStyle(fontWeight: FontWeight.w700)),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            onPressed: () => ref.read(authServiceProvider).signOut(),
          ),
        ],
      ),
      body: ValueListenableBuilder<Box<QueueToken>>(
        valueListenable: queueBox.listenable(),
        builder: (context, box, _) {
          final tokens = box.values.toList();
          tokens.sort((a, b) => a.queueNumber.compareTo(b.queueNumber));

          // Split by active vs history
          final active = tokens.where((t) => t.status == 'Waiting' || t.status == 'Serving').toList();
          final history = tokens.where((t) => t.status == 'Completed' || t.status == 'Cancelled').toList();

          if (tokens.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_outlined, size: 64, color: Colors.black26),
                  SizedBox(height: 16),
                  Text('No appointments yet', style: TextStyle(fontSize: 16, color: Colors.black45)),
                ],
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (active.isNotEmpty) ...[
                _sectionHeader('Active Queue (${active.length})'),
                const SizedBox(height: 10),
                ...active.map((t) => _buildAdminTokenCard(context, t, queueService, isActive: true)),
                const SizedBox(height: 24),
              ],
              if (history.isNotEmpty) ...[
                _sectionHeader('History (${history.length})'),
                const SizedBox(height: 10),
                ...history.map((t) => _buildAdminTokenCard(context, t, queueService, isActive: false)),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.black45, letterSpacing: 0.5));
  }

  Widget _buildAdminTokenCard(BuildContext context, QueueToken token, QueueService queueService, {required bool isActive}) {
    final statusColor = _getStatusColor(token.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '${token.queueNumber}',
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: statusColor),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Token #${token.queueNumber}', style: const TextStyle(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          token.status,
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: statusColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (isActive) ...[
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Row(
                children: [
                  if (token.status == 'Waiting')
                    Expanded(
                      child: _actionButton(
                        label: 'Serve Now',
                        icon: Icons.play_arrow_rounded,
                        color: const Color(0xFF2563EB),
                        onTap: () => queueService.markAsServing(token.id),
                      ),
                    ),
                  if (token.status == 'Serving') ...[
                    Expanded(
                      child: _actionButton(
                        label: 'Complete',
                        icon: Icons.check_rounded,
                        color: Colors.green,
                        onTap: () => queueService.markAsCompleted(token.id),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  if (token.status == 'Waiting') const SizedBox(width: 8),
                  Expanded(
                    child: _actionButton(
                      label: 'Cancel',
                      icon: Icons.close_rounded,
                      color: Colors.red.shade400,
                      onTap: () => queueService.markAsCancelled(token.id),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _actionButton({required String label, required IconData icon, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Waiting': return Colors.orange;
      case 'Serving': return const Color(0xFF2563EB);
      case 'Completed': return Colors.green;
      case 'Cancelled': return Colors.red;
      default: return Colors.grey;
    }
  }
}
