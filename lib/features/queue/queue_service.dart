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
  static const int averageServiceTimeMinutes = 15;

  QueueService(this._repository);

  /// Generates a new token for an appointment
  Future<QueueToken> generateToken(String appointmentId) async {
    final tokens = _repository.getQueueTokens();
    
    // Find highest queue number for today
    // For simplicity, we just take the highest number overall or 0 if empty
    int maxNumber = 0;
    for (var t in tokens) {
      if (t.queueNumber > maxNumber) {
        maxNumber = t.queueNumber;
      }
    }

    final newNumber = maxNumber + 1;
    final currentServing = getCurrentServingNumber();
    
    // Calculate wait time
    final waitTime = (newNumber - currentServing) * averageServiceTimeMinutes;

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
      // Return the lowest serving number
      servingTokens.sort((a, b) => a.queueNumber.compareTo(b.queueNumber));
      return servingTokens.first.queueNumber;
    }
    
    // If none are serving, find the highest completed token
    final completedTokens = tokens.where((t) => t.status == 'Completed').toList();
    if (completedTokens.isNotEmpty) {
      completedTokens.sort((a, b) => b.queueNumber.compareTo(a.queueNumber));
      return completedTokens.first.queueNumber;
    }

    return 0; // Queue hasn't started
  }

  int getEstimatedWaitTime(int queueNumber) {
    final currentServing = getCurrentServingNumber();
    final waitTime = (queueNumber - currentServing) * averageServiceTimeMinutes;
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
