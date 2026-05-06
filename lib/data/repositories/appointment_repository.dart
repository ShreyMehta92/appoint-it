import 'package:uuid/uuid.dart';
import '../models/appointment_model.dart';
import '../models/sync_task_model.dart';
import '../datasources/local_data_source.dart';

class AppointmentRepository {
  final LocalDataSource localDataSource;

  AppointmentRepository(this.localDataSource);

  Future<void> bookAppointment(Appointment appointment) async {
    // 1. Save locally
    await localDataSource.saveAppointment(appointment);

    // 2. Queue for sync
    final syncTask = SyncTask(
      id: const Uuid().v4(),
      collection: 'appointments',
      documentId: appointment.id,
      operation: 'create',
      payload: appointment.toJson(),
      status: 'pending',
      createdAt: DateTime.now(),
    );
    await localDataSource.saveSyncTask(syncTask);

    // Syncing will be handled by a background SyncService
  }

  Future<void> updateAppointmentStatus(String id, String newStatus) async {
    final appointments = localDataSource.getAppointments();
    final index = appointments.indexWhere((a) => a.id == id);
    if (index != -1) {
      final updated = appointments[index].copyWith(status: newStatus);
      await localDataSource.saveAppointment(updated);

      final syncTask = SyncTask(
        id: const Uuid().v4(),
        collection: 'appointments',
        documentId: id,
        operation: 'update',
        payload: updated.toJson(),
        status: 'pending',
        createdAt: DateTime.now(),
      );
      await localDataSource.saveSyncTask(syncTask);
    }
  }

  List<Appointment> getAllAppointments() {
    return localDataSource.getAppointments();
  }
}
