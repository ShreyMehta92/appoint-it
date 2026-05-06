import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../data/datasources/local_data_source.dart';
import '../data/datasources/remote_data_source.dart';
import '../data/repositories/appointment_repository.dart';
import '../data/repositories/queue_repository.dart';
import '../data/models/appointment_model.dart';
import '../data/models/queue_token_model.dart';
import '../data/models/sync_task_model.dart';

// Firestore Provider
final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

// Hive Box Providers
final appointmentBoxProvider = Provider<Box<Appointment>>((ref) {
  return Hive.box<Appointment>('appointments');
});

final queueTokenBoxProvider = Provider<Box<QueueToken>>((ref) {
  return Hive.box<QueueToken>('queue_tokens');
});

final syncTaskBoxProvider = Provider<Box<SyncTask>>((ref) {
  return Hive.box<SyncTask>('sync_tasks');
});

// DataSource Providers
final localDataSourceProvider = Provider<LocalDataSource>((ref) {
  return LocalDataSource(
    appointmentBox: ref.watch(appointmentBoxProvider),
    queueTokenBox: ref.watch(queueTokenBoxProvider),
    syncTaskBox: ref.watch(syncTaskBoxProvider),
  );
});

final remoteDataSourceProvider = Provider<RemoteDataSource>((ref) {
  return RemoteDataSource(ref.watch(firestoreProvider));
});

// Repository Providers
final appointmentRepositoryProvider = Provider<AppointmentRepository>((ref) {
  return AppointmentRepository(ref.watch(localDataSourceProvider));
});

final queueRepositoryProvider = Provider<QueueRepository>((ref) {
  return QueueRepository(ref.watch(localDataSourceProvider));
});
