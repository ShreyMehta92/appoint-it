import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'appointment_model.freezed.dart';
part 'appointment_model.g.dart';

@freezed
class Appointment with _$Appointment {
  @HiveType(typeId: 0, adapterName: 'AppointmentAdapter')
  const factory Appointment({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @HiveField(2) required String serviceType,
    @HiveField(3) required DateTime date,
    @HiveField(4) required String timeSlot,
    @HiveField(5) required String status, // 'Scheduled', 'In Progress', 'Completed', 'Cancelled'
    @HiveField(6) required DateTime createdAt,
  }) = _Appointment;

  factory Appointment.fromJson(Map<String, dynamic> json) => _$AppointmentFromJson(json);
}
