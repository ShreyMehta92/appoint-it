import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'sync_task_model.freezed.dart';
part 'sync_task_model.g.dart';

@freezed
class SyncTask with _$SyncTask {
  @HiveType(typeId: 4, adapterName: 'SyncTaskAdapter')
  const factory SyncTask({
    @HiveField(0) required String id,
    @HiveField(1) required String collection,
    @HiveField(2) required String documentId,
    @HiveField(3) required String operation, // 'create', 'update', 'delete'
    @HiveField(4) required Map<String, dynamic> payload,
    @HiveField(5) required String status, // 'pending', 'completed', 'failed'
    @HiveField(6) required DateTime createdAt,
  }) = _SyncTask;

  factory SyncTask.fromJson(Map<String, dynamic> json) => _$SyncTaskFromJson(json);
}
