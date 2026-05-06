import 'package:uuid/uuid.dart';
import '../models/queue_token_model.dart';
import '../models/sync_task_model.dart';
import '../datasources/local_data_source.dart';

class QueueRepository {
  final LocalDataSource localDataSource;

  QueueRepository(this.localDataSource);

  Future<void> assignQueueToken(QueueToken token) async {
    await localDataSource.saveQueueToken(token);

    final syncTask = SyncTask(
      id: const Uuid().v4(),
      collection: 'queue_tokens',
      documentId: token.id,
      operation: 'create',
      payload: token.toJson(),
      status: 'pending',
      createdAt: DateTime.now(),
    );
    await localDataSource.saveSyncTask(syncTask);
  }

  Future<void> updateTokenStatus(String id, String newStatus) async {
    final tokens = localDataSource.getQueueTokens();
    final index = tokens.indexWhere((t) => t.id == id);
    if (index != -1) {
      final updated = tokens[index].copyWith(status: newStatus);
      await localDataSource.saveQueueToken(updated);

      final syncTask = SyncTask(
        id: const Uuid().v4(),
        collection: 'queue_tokens',
        documentId: id,
        operation: 'update',
        payload: updated.toJson(),
        status: 'pending',
        createdAt: DateTime.now(),
      );
      await localDataSource.saveSyncTask(syncTask);
    }
  }

  List<QueueToken> getQueueTokens() {
    return localDataSource.getQueueTokens();
  }
}
