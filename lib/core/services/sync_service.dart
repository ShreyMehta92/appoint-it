import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/local_data_source.dart';
import '../../data/datasources/remote_data_source.dart';
import '../../providers/data_providers.dart';

final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService(
    ref.watch(localDataSourceProvider),
    ref.watch(remoteDataSourceProvider),
  );
});

class SyncService {
  final LocalDataSource _localDataSource;
  final RemoteDataSource _remoteDataSource;
  StreamSubscription? _connectivitySubscription;
  bool _isSyncing = false;

  SyncService(this._localDataSource, this._remoteDataSource);

  void startListening() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      if (results.contains(ConnectivityResult.mobile) || results.contains(ConnectivityResult.wifi)) {
        _syncPendingTasks();
      }
    });
    // Trigger sync on start
    _syncPendingTasks();
  }

  void stopListening() {
    _connectivitySubscription?.cancel();
  }

  Future<void> _syncPendingTasks() async {
    if (_isSyncing) return;
    _isSyncing = true;

    try {
      final tasks = _localDataSource.getPendingSyncTasks();
      for (final task in tasks) {
        try {
          await _remoteDataSource.syncDocument(
            collection: task.collection,
            documentId: task.documentId,
            operation: task.operation,
            payload: task.payload,
          );
          
          // Mark as completed or delete task on success
          await _localDataSource.deleteSyncTask(task.id);
        } catch (e) {
          debugPrint('Sync failed for task ${task.id}: $e');
          // Update status to failed or just leave it pending for next retry
        }
      }
    } finally {
      _isSyncing = false;
    }
  }
}
