import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'queue_token_model.freezed.dart';
part 'queue_token_model.g.dart';

@freezed
class QueueToken with _$QueueToken {
  @HiveType(typeId: 1, adapterName: 'QueueTokenAdapter')
  const factory QueueToken({
    @HiveField(0) required String id,
    @HiveField(1) required String appointmentId,
    @HiveField(2) required int queueNumber,
    @HiveField(3) required String status, // 'Waiting', 'Serving', 'Completed', 'Cancelled'
    @HiveField(4) required int estimatedWaitTimeInMinutes,
    @HiveField(5) required DateTime createdAt,
  }) = _QueueToken;

  factory QueueToken.fromJson(Map<String, dynamic> json) => _$QueueTokenFromJson(json);
}
