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
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authServiceProvider).signOut(),
          ),
        ],
      ),
      body: ValueListenableBuilder<Box<QueueToken>>(
        valueListenable: queueBox.listenable(),
        builder: (context, box, _) {
          final tokens = box.values.toList();
          tokens.sort((a, b) => a.queueNumber.compareTo(b.queueNumber));

          if (tokens.isEmpty) {
            return const Center(child: Text('No appointments in the queue.'));
          }

          return ListView.builder(
            itemCount: tokens.length,
            itemBuilder: (context, index) {
              final token = tokens[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Token #${token.queueNumber}',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Chip(
                            label: Text(token.status),
                            backgroundColor: _getStatusColor(token.status),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (token.status == 'Waiting')
                            ElevatedButton.icon(
                              icon: const Icon(Icons.play_arrow),
                              label: const Text('Serve'),
                              onPressed: () => queueService.markAsServing(token.id),
                            ),
                          if (token.status == 'Serving')
                            ElevatedButton.icon(
                              icon: const Icon(Icons.check),
                              label: const Text('Complete'),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                              onPressed: () => queueService.markAsCompleted(token.id),
                            ),
                          if (token.status == 'Waiting' || token.status == 'Serving')
                            TextButton.icon(
                              icon: const Icon(Icons.cancel),
                              label: const Text('Cancel', style: TextStyle(color: Colors.red)),
                              onPressed: () => queueService.markAsCancelled(token.id),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Waiting':
        return Colors.orange.shade200;
      case 'Serving':
        return Colors.green.shade200;
      case 'Completed':
        return Colors.grey.shade300;
      case 'Cancelled':
        return Colors.red.shade200;
      default:
        return Colors.blue.shade200;
    }
  }
}
