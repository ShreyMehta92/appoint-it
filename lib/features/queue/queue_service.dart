import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../data/models/queue_token_model.dart';
import '../../data/repositories/queue_repository.dart';
import '../../providers/data_providers.dart';

final queueServiceProvider = Provider<QueueService>((ref) {
  return QueueService(ref.watch(queueRepositoryProvider));
});

class QueueService {
  final QueueRepository _repository;
  static const int fallbackServiceTimeMinutes = 15;

  QueueService(this._repository);

  /// Calculates the average service time based on the last 3 completed appointments.
  /// Falls back to the default value if insufficient data exists.
  int getDynamicAverageServiceTime() {
    final tokens = _repository.getQueueTokens();
    final completed = tokens.where((t) => t.status == 'Completed').toList();

    if (completed.isEmpty) return fallbackServiceTimeMinutes;

    // Sort by createdAt descending to get most recent completions
    completed.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    // Take up to the last 3
    final recent = completed.take(3).toList();

    if (recent.length >= 2) {
      // Calculate average gap between consecutive creations as a proxy for service time
      int totalMinutes = 0;
      for (int i = 0; i < recent.length - 1; i++) {
        final diff = recent[i].createdAt.difference(recent[i + 1].createdAt).inMinutes.abs();
        totalMinutes += diff.clamp(1, 60); // clamp to sane bounds
      }
      final avg = (totalMinutes / (recent.length - 1)).round();
      return avg > 0 ? avg : fallbackServiceTimeMinutes;
    }

    return fallbackServiceTimeMinutes;
  }

  /// Generates a new token for an appointment
  Future<QueueToken> generateToken(String appointmentId) async {
    final tokens = _repository.getQueueTokens();

    int maxNumber = 0;
    for (var t in tokens) {
      if (t.queueNumber > maxNumber) maxNumber = t.queueNumber;
    }

    final newNumber = maxNumber + 1;
    final currentServing = getCurrentServingNumber();
    final avgTime = getDynamicAverageServiceTime();
    final waitTime = (newNumber - currentServing) * avgTime;

    final token = QueueToken(
      id: const Uuid().v4(),
      appointmentId: appointmentId,
      queueNumber: newNumber,
      status: 'Waiting',
      estimatedWaitTimeInMinutes: waitTime > 0 ? waitTime : 0,
      createdAt: DateTime.now(),
    );

    await _repository.assignQueueToken(token);
    return token;
  }

  int getCurrentServingNumber() {
    final tokens = _repository.getQueueTokens();
    final servingTokens = tokens.where((t) => t.status == 'Serving').toList();
    if (servingTokens.isNotEmpty) {
      servingTokens.sort((a, b) => a.queueNumber.compareTo(b.queueNumber));
      return servingTokens.first.queueNumber;
    }

    final completedTokens = tokens.where((t) => t.status == 'Completed').toList();
    if (completedTokens.isNotEmpty) {
      completedTokens.sort((a, b) => b.queueNumber.compareTo(a.queueNumber));
      return completedTokens.first.queueNumber;
    }

    return 0;
  }

  int getEstimatedWaitTime(int queueNumber) {
    final currentServing = getCurrentServingNumber();
    final avgTime = getDynamicAverageServiceTime();
    final waitTime = (queueNumber - currentServing) * avgTime;
    return waitTime > 0 ? waitTime : 0;
  }

  Future<void> markAsServing(String tokenId) async {
    await _repository.updateTokenStatus(tokenId, 'Serving');
  }

  Future<void> markAsCompleted(String tokenId) async {
    await _repository.updateTokenStatus(tokenId, 'Completed');
  }

  Future<void> markAsCancelled(String tokenId) async {
    await _repository.updateTokenStatus(tokenId, 'Cancelled');
  }
}
