// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queue_token_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QueueTokenAdapter extends TypeAdapter<_$QueueTokenImpl> {
  @override
  final int typeId = 1;

  @override
  _$QueueTokenImpl read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _$QueueTokenImpl(
      id: fields[0] as String,
      appointmentId: fields[1] as String,
      queueNumber: fields[2] as int,
      status: fields[3] as String,
      estimatedWaitTimeInMinutes: fields[4] as int,
      createdAt: fields[5] as DateTime,
      servingStartedAt: fields[6] as DateTime?,
      completedAt: fields[7] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, _$QueueTokenImpl obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.appointmentId)
      ..writeByte(2)
      ..write(obj.queueNumber)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.estimatedWaitTimeInMinutes)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.servingStartedAt)
      ..writeByte(7)
      ..write(obj.completedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QueueTokenAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QueueTokenImpl _$$QueueTokenImplFromJson(Map<String, dynamic> json) =>
    _$QueueTokenImpl(
      id: json['id'] as String,
      appointmentId: json['appointmentId'] as String,
      queueNumber: (json['queueNumber'] as num).toInt(),
      status: json['status'] as String,
      estimatedWaitTimeInMinutes:
          (json['estimatedWaitTimeInMinutes'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      servingStartedAt: json['servingStartedAt'] == null
          ? null
          : DateTime.parse(json['servingStartedAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
    );

Map<String, dynamic> _$$QueueTokenImplToJson(_$QueueTokenImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'appointmentId': instance.appointmentId,
      'queueNumber': instance.queueNumber,
      'status': instance.status,
      'estimatedWaitTimeInMinutes': instance.estimatedWaitTimeInMinutes,
      'createdAt': instance.createdAt.toIso8601String(),
      'servingStartedAt': instance.servingStartedAt?.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
    };
