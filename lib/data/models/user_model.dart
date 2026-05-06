import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  @HiveType(typeId: 2, adapterName: 'UserAdapter')
  const factory UserModel({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @HiveField(2) required String phone,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}
