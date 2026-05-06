import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../providers/auth_providers.dart';
import '../../data/models/queue_token_model.dart';
import '../../providers/data_providers.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueBox = ref.watch(queueTokenBoxProvider);
    final auth = ref.watch(authServiceProvider);
    final user = ref.watch(authStateProvider).value;
    final roleAsync = user != null ? ref.watch(userRoleProvider(user.uid)) : const AsyncValue<String?>.data(null);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          if (roleAsync.value == 'admin')
            IconButton(
              icon: const Icon(Icons.admin_panel_settings),
              tooltip: 'Admin Area',
              onPressed: () => context.push('/admin'),
            ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => auth.signOut(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Welcome back!',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ValueListenableBuilder<Box<QueueToken>>(
              valueListenable: queueBox.listenable(),
              builder: (context, box, _) {
                final tokens = box.values;
                final waitingCount = tokens.where((t) => t.status == 'Waiting').length;
                final servingCount = tokens.where((t) => t.status == 'Serving').length;
                
                return Card(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem('Waiting', waitingCount),
                        _buildStatItem('Serving', servingCount),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
            const Text(
              'Quick Actions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _buildActionCard(
                  context,
                  title: 'Book\nAppointment',
                  icon: Icons.calendar_today,
                  color: Colors.blue.shade100,
                  onTap: () => context.push('/booking'),
                ),
                _buildActionCard(
                  context,
                  title: 'Live\nQueue',
                  icon: Icons.people_alt,
                  color: Colors.orange.shade100,
                  onTap: () => context.push('/queue'),
                ),
                _buildActionCard(
                  context,
                  title: 'Search\nRecords',
                  icon: Icons.search,
                  color: Colors.green.shade100,
                  onTap: () => context.push('/search'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, int count) {
    return Column(
      children: [
        Text(
          '$count',
          style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Colors.black54),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
