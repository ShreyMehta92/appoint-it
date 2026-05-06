import 'package:uuid/uuid.dart';
import '../models/appointment_model.dart';
import '../models/sync_task_model.dart';
import '../datasources/local_data_source.dart';

class AppointmentRepository {
  final LocalDataSource localDataSource;

  AppointmentRepository(this.localDataSource);

  /// Returns true if the given [dateTime] conflicts with any existing active appointment.
  /// A conflict is defined as another appointment within a ±15 minute window on the same day.
  bool isSlotConflicted(DateTime dateTime) {
    const lockWindowMinutes = 15;
    final existing = localDataSource.getAppointments();

    for (final appt in existing) {
      // Ignore cancelled/completed appointments — they free up the slot
      if (appt.status == 'Cancelled' || appt.status == 'Completed') continue;

      // Must be the same calendar day
      if (appt.date.year != dateTime.year ||
          appt.date.month != dateTime.month ||
          appt.date.day != dateTime.day) continue;

      final diffMinutes = appt.date.difference(dateTime).inMinutes.abs();
      if (diffMinutes < lockWindowMinutes) return true;
    }
    return false;
  }

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
