import 'package:hive_flutter/hive_flutter.dart';
import '../models/appointment_model.dart';
import '../models/queue_token_model.dart';
import '../models/sync_task_model.dart';

class LocalDataSource {
  final Box<Appointment> appointmentBox;
  final Box<QueueToken> queueTokenBox;
  final Box<SyncTask> syncTaskBox;

  LocalDataSource({
    required this.appointmentBox,
    required this.queueTokenBox,
    required this.syncTaskBox,
  });

  // Appointment CRUD
  Future<void> saveAppointment(Appointment appointment) async {
    await appointmentBox.put(appointment.id, appointment);
  }

  List<Appointment> getAppointments() {
    return appointmentBox.values.toList();
  }

  Future<void> deleteAppointment(String id) async {
    await appointmentBox.delete(id);
  }

  // Queue Token CRUD
  Future<void> saveQueueToken(QueueToken token) async {
    await queueTokenBox.put(token.id, token);
  }

  List<QueueToken> getQueueTokens() {
    return queueTokenBox.values.toList();
  }

  // Sync Task CRUD
  Future<void> saveSyncTask(SyncTask task) async {
    await syncTaskBox.put(task.id, task);
  }

  List<SyncTask> getPendingSyncTasks() {
    return syncTaskBox.values.where((t) => t.status == 'pending').toList();
  }

  Future<void> deleteSyncTask(String id) async {
    await syncTaskBox.delete(id);
  }
}
