import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../data/models/queue_token_model.dart';
import '../../providers/data_providers.dart';
import 'queue_service.dart';

class QueueStatusScreen extends ConsumerWidget {
  const QueueStatusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueService = ref.watch(queueServiceProvider);
    final queueBox = ref.watch(queueTokenBoxProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Live Queue Status')),
      body: ValueListenableBuilder<Box<QueueToken>>(
        valueListenable: queueBox.listenable(),
        builder: (context, box, _) {
          final tokens = box.values.toList();
          
          // Sort tokens by queue number
          tokens.sort((a, b) => a.queueNumber.compareTo(b.queueNumber));
          
          final currentServingToken = queueService.getCurrentServingNumber();
          
          // Get user's active tokens (in a real app, filter by User ID)
          // For now, we'll just show all active waiting/serving tokens
          final activeTokens = tokens.where((t) => t.status == 'Waiting' || t.status == 'Serving').toList();

          return Column(
            children: [
              _buildHeaderStatus(context, currentServingToken),
              const Divider(thickness: 2),
              Expanded(
                child: activeTokens.isEmpty
                    ? const Center(child: Text('No active queue tokens right now.'))
                    : ListView.builder(
                        itemCount: activeTokens.length,
                        itemBuilder: (context, index) {
                          final token = activeTokens[index];
                          final waitTime = queueService.getEstimatedWaitTime(token.queueNumber);
                          
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            elevation: token.status == 'Serving' ? 4 : 1,
                            color: token.status == 'Serving' ? Colors.green.shade50 : null,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: token.status == 'Serving' ? Colors.green : Colors.blue,
                                child: Text('${token.queueNumber}', style: const TextStyle(color: Colors.white)),
                              ),
                              title: Text('Token #${token.queueNumber}'),
                              subtitle: Text('Status: ${token.status}'),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text('Est. Wait'),
                                  Text(
                                    token.status == 'Serving' ? 'Now' : '${waitTime}m',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: token.status == 'Serving' ? Colors.green : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeaderStatus(BuildContext context, int currentServing) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              const Text('Now Serving', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              Text(
                currentServing > 0 ? '#$currentServing' : '--',
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Icon(Icons.arrow_forward_ios, size: 40, color: Colors.black26),
          Column(
            children: [
              const Text('Avg Service Time', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Text(
                '${QueueService.averageServiceTimeMinutes} min',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
