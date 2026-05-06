import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'admin_model.freezed.dart';
part 'admin_model.g.dart';

@freezed
class AdminModel with _$AdminModel {
  @HiveType(typeId: 3, adapterName: 'AdminAdapter')
  const factory AdminModel({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @HiveField(2) required String email,
    @HiveField(3) required String role, // 'SuperAdmin', 'Receptionist'
  }) = _AdminModel;

  factory AdminModel.fromJson(Map<String, dynamic> json) => _$AdminModelFromJson(json);
}
