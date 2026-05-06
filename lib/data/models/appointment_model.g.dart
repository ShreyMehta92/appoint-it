// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppointmentAdapter extends TypeAdapter<_$AppointmentImpl> {
  @override
  final int typeId = 0;

  @override
  _$AppointmentImpl read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _$AppointmentImpl(
      id: fields[0] as String,
      name: fields[1] as String,
      serviceType: fields[2] as String,
      date: fields[3] as DateTime,
      timeSlot: fields[4] as String,
      status: fields[5] as String,
      createdAt: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, _$AppointmentImpl obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.serviceType)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.timeSlot)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppointmentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppointmentImpl _$$AppointmentImplFromJson(Map<String, dynamic> json) =>
    _$AppointmentImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      serviceType: json['serviceType'] as String,
      date: DateTime.parse(json['date'] as String),
      timeSlot: json['timeSlot'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$AppointmentImplToJson(_$AppointmentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'serviceType': instance.serviceType,
      'date': instance.date.toIso8601String(),
      'timeSlot': instance.timeSlot,
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
    };
