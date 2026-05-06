// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_task_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SyncTaskAdapter extends TypeAdapter<_$SyncTaskImpl> {
  @override
  final int typeId = 4;

  @override
  _$SyncTaskImpl read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _$SyncTaskImpl(
      id: fields[0] as String,
      collection: fields[1] as String,
      documentId: fields[2] as String,
      operation: fields[3] as String,
      payload: (fields[4] as Map).cast<String, dynamic>(),
      status: fields[5] as String,
      createdAt: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, _$SyncTaskImpl obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.collection)
      ..writeByte(2)
      ..write(obj.documentId)
      ..writeByte(3)
      ..write(obj.operation)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.payload);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SyncTaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SyncTaskImpl _$$SyncTaskImplFromJson(Map<String, dynamic> json) =>
    _$SyncTaskImpl(
      id: json['id'] as String,
      collection: json['collection'] as String,
      documentId: json['documentId'] as String,
      operation: json['operation'] as String,
      payload: json['payload'] as Map<String, dynamic>,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$SyncTaskImplToJson(_$SyncTaskImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'collection': instance.collection,
      'documentId': instance.documentId,
      'operation': instance.operation,
      'payload': instance.payload,
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
    };
