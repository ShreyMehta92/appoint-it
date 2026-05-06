import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../data/models/queue_token_model.dart';
import '../../providers/data_providers.dart';
import 'queue_service.dart';

class QueueStatusScreen extends ConsumerStatefulWidget {
  const QueueStatusScreen({super.key});

  @override
  ConsumerState<QueueStatusScreen> createState() => _QueueStatusScreenState();
}

class _QueueStatusScreenState extends ConsumerState<QueueStatusScreen> {
  bool _hasShownYourTurnDialog = false;

  void _checkAndShowYourTurnAlert(List<QueueToken> activeTokens, int currentServing) {
    // Find the next-in-line (position #1 after the one currently serving)
    final waitingTokens = activeTokens.where((t) => t.status == 'Waiting').toList();
    if (waitingTokens.isEmpty) return;
    waitingTokens.sort((a, b) => a.queueNumber.compareTo(b.queueNumber));
    final nextToken = waitingTokens.first;

    // If the next token is exactly 1 ahead of the serving number, it's "Your Turn"
    if (nextToken.queueNumber == currentServing + 1 && !_hasShownYourTurnDialog) {
      _hasShownYourTurnDialog = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showYourTurnDialog(nextToken.queueNumber);
      });
    } else if (nextToken.queueNumber != currentServing + 1) {
      _hasShownYourTurnDialog = false;
    }
  }

  void _showYourTurnDialog(int tokenNumber) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.notifications_active, color: Colors.green, size: 40),
            ),
            const SizedBox(height: 20),
            const Text(
              "You're Next!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Token #$tokenNumber is up next.\nPlease be ready!',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, color: Colors.black54),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Got it!', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final queueService = ref.watch(queueServiceProvider);
    final queueBox = ref.watch(queueTokenBoxProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        title: const Text('Live Queue', style: TextStyle(fontWeight: FontWeight.w700)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: ValueListenableBuilder<Box<QueueToken>>(
        valueListenable: queueBox.listenable(),
        builder: (context, box, _) {
          final tokens = box.values.toList();
          tokens.sort((a, b) => a.queueNumber.compareTo(b.queueNumber));

          final currentServingNumber = queueService.getCurrentServingNumber();
          final avgTime = queueService.getDynamicAverageServiceTime();
          final activeTokens = tokens.where((t) => t.status == 'Waiting' || t.status == 'Serving').toList();

          _checkAndShowYourTurnAlert(activeTokens, currentServingNumber);

          return Column(
            children: [
              _buildHeroHeader(context, currentServingNumber, avgTime),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Row(
                  children: [
                    Text(
                      '${activeTokens.length} in queue',
                      style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black54),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: activeTokens.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle_outline, size: 64, color: Colors.green),
                            SizedBox(height: 16),
                            Text('Queue is clear!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        itemCount: activeTokens.length,
                        itemBuilder: (context, index) {
                          final token = activeTokens[index];
                          final waitTime = queueService.getEstimatedWaitTime(token.queueNumber);
                          final isServing = token.status == 'Serving';

                          return _buildTokenCard(token, waitTime, isServing, index);
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeroHeader(BuildContext context, int currentServing, int avgTime) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Now Serving', style: TextStyle(fontSize: 13, color: Colors.black45, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                const SizedBox(height: 6),
                Text(
                  currentServing > 0 ? '#$currentServing' : '--',
                  style: const TextStyle(fontSize: 52, fontWeight: FontWeight.w800, color: Color(0xFF2563EB), height: 1),
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            height: 60,
            color: Colors.black12,
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Avg. Per Person', style: TextStyle(fontSize: 13, color: Colors.black45, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                const SizedBox(height: 6),
                Text(
                  '$avgTime min',
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.black87),
                ),
                const Text('(live estimate)', style: TextStyle(fontSize: 11, color: Colors.black38)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTokenCard(QueueToken token, int waitTime, bool isServing, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isServing ? const Color(0xFFECFDF5) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isServing ? Colors.green.shade300 : Colors.black.withOpacity(0.06),
          width: isServing ? 1.5 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isServing ? Colors.green : const Color(0xFF2563EB),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  '${token.queueNumber}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Token #${token.queueNumber}',
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: isServing ? Colors.green.shade100 : Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          token.status,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isServing ? Colors.green.shade700 : Colors.orange.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  isServing ? 'Now' : '~${waitTime}m',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: isServing ? Colors.green : const Color(0xFF2563EB),
                  ),
                ),
                Text(
                  isServing ? 'serving' : 'wait',
                  style: const TextStyle(fontSize: 11, color: Colors.black38),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
