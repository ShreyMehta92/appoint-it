// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'queue_token_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

QueueToken _$QueueTokenFromJson(Map<String, dynamic> json) {
  return _QueueToken.fromJson(json);
}

/// @nodoc
mixin _$QueueToken {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get appointmentId => throw _privateConstructorUsedError;
  @HiveField(2)
  int get queueNumber => throw _privateConstructorUsedError;
  @HiveField(3)
  String get status =>
      throw _privateConstructorUsedError; // 'Waiting', 'Serving', 'Completed', 'Cancelled'
  @HiveField(4)
  int get estimatedWaitTimeInMinutes => throw _privateConstructorUsedError;
  @HiveField(5)
  DateTime get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $QueueTokenCopyWith<QueueToken> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QueueTokenCopyWith<$Res> {
  factory $QueueTokenCopyWith(
          QueueToken value, $Res Function(QueueToken) then) =
      _$QueueTokenCopyWithImpl<$Res, QueueToken>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String appointmentId,
      @HiveField(2) int queueNumber,
      @HiveField(3) String status,
      @HiveField(4) int estimatedWaitTimeInMinutes,
      @HiveField(5) DateTime createdAt});
}

/// @nodoc
class _$QueueTokenCopyWithImpl<$Res, $Val extends QueueToken>
    implements $QueueTokenCopyWith<$Res> {
  _$QueueTokenCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? appointmentId = null,
    Object? queueNumber = null,
    Object? status = null,
    Object? estimatedWaitTimeInMinutes = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      appointmentId: null == appointmentId
          ? _value.appointmentId
          : appointmentId // ignore: cast_nullable_to_non_nullable
              as String,
      queueNumber: null == queueNumber
          ? _value.queueNumber
          : queueNumber // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      estimatedWaitTimeInMinutes: null == estimatedWaitTimeInMinutes
          ? _value.estimatedWaitTimeInMinutes
          : estimatedWaitTimeInMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QueueTokenImplCopyWith<$Res>
    implements $QueueTokenCopyWith<$Res> {
  factory _$$QueueTokenImplCopyWith(
          _$QueueTokenImpl value, $Res Function(_$QueueTokenImpl) then) =
      __$$QueueTokenImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String appointmentId,
      @HiveField(2) int queueNumber,
      @HiveField(3) String status,
      @HiveField(4) int estimatedWaitTimeInMinutes,
      @HiveField(5) DateTime createdAt});
}

/// @nodoc
class __$$QueueTokenImplCopyWithImpl<$Res>
    extends _$QueueTokenCopyWithImpl<$Res, _$QueueTokenImpl>
    implements _$$QueueTokenImplCopyWith<$Res> {
  __$$QueueTokenImplCopyWithImpl(
      _$QueueTokenImpl _value, $Res Function(_$QueueTokenImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? appointmentId = null,
    Object? queueNumber = null,
    Object? status = null,
    Object? estimatedWaitTimeInMinutes = null,
    Object? createdAt = null,
  }) {
    return _then(_$QueueTokenImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      appointmentId: null == appointmentId
          ? _value.appointmentId
          : appointmentId // ignore: cast_nullable_to_non_nullable
              as String,
      queueNumber: null == queueNumber
          ? _value.queueNumber
          : queueNumber // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      estimatedWaitTimeInMinutes: null == estimatedWaitTimeInMinutes
          ? _value.estimatedWaitTimeInMinutes
          : estimatedWaitTimeInMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
@HiveType(typeId: 1, adapterName: 'QueueTokenAdapter')
class _$QueueTokenImpl implements _QueueToken {
  const _$QueueTokenImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.appointmentId,
      @HiveField(2) required this.queueNumber,
      @HiveField(3) required this.status,
      @HiveField(4) required this.estimatedWaitTimeInMinutes,
      @HiveField(5) required this.createdAt});

  factory _$QueueTokenImpl.fromJson(Map<String, dynamic> json) =>
      _$$QueueTokenImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String appointmentId;
  @override
  @HiveField(2)
  final int queueNumber;
  @override
  @HiveField(3)
  final String status;
// 'Waiting', 'Serving', 'Completed', 'Cancelled'
  @override
  @HiveField(4)
  final int estimatedWaitTimeInMinutes;
  @override
  @HiveField(5)
  final DateTime createdAt;

  @override
  String toString() {
    return 'QueueToken(id: $id, appointmentId: $appointmentId, queueNumber: $queueNumber, status: $status, estimatedWaitTimeInMinutes: $estimatedWaitTimeInMinutes, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QueueTokenImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.appointmentId, appointmentId) ||
                other.appointmentId == appointmentId) &&
            (identical(other.queueNumber, queueNumber) ||
                other.queueNumber == queueNumber) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.estimatedWaitTimeInMinutes,
                    estimatedWaitTimeInMinutes) ||
                other.estimatedWaitTimeInMinutes ==
                    estimatedWaitTimeInMinutes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, appointmentId, queueNumber,
      status, estimatedWaitTimeInMinutes, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QueueTokenImplCopyWith<_$QueueTokenImpl> get copyWith =>
      __$$QueueTokenImplCopyWithImpl<_$QueueTokenImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QueueTokenImplToJson(
      this,
    );
  }
}

abstract class _QueueToken implements QueueToken {
  const factory _QueueToken(
      {@HiveField(0) required final String id,
      @HiveField(1) required final String appointmentId,
      @HiveField(2) required final int queueNumber,
      @HiveField(3) required final String status,
      @HiveField(4) required final int estimatedWaitTimeInMinutes,
      @HiveField(5) required final DateTime createdAt}) = _$QueueTokenImpl;

  factory _QueueToken.fromJson(Map<String, dynamic> json) =
      _$QueueTokenImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get appointmentId;
  @override
  @HiveField(2)
  int get queueNumber;
  @override
  @HiveField(3)
  String get status;
  @override // 'Waiting', 'Serving', 'Completed', 'Cancelled'
  @HiveField(4)
  int get estimatedWaitTimeInMinutes;
  @override
  @HiveField(5)
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$QueueTokenImplCopyWith<_$QueueTokenImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
