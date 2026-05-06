// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_task_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SyncTask _$SyncTaskFromJson(Map<String, dynamic> json) {
  return _SyncTask.fromJson(json);
}

/// @nodoc
mixin _$SyncTask {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get collection => throw _privateConstructorUsedError;
  @HiveField(2)
  String get documentId => throw _privateConstructorUsedError;
  @HiveField(3)
  String get operation =>
      throw _privateConstructorUsedError; // 'create', 'update', 'delete'
  @HiveField(4)
  Map<String, dynamic> get payload => throw _privateConstructorUsedError;
  @HiveField(5)
  String get status =>
      throw _privateConstructorUsedError; // 'pending', 'completed', 'failed'
  @HiveField(6)
  DateTime get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SyncTaskCopyWith<SyncTask> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SyncTaskCopyWith<$Res> {
  factory $SyncTaskCopyWith(SyncTask value, $Res Function(SyncTask) then) =
      _$SyncTaskCopyWithImpl<$Res, SyncTask>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String collection,
      @HiveField(2) String documentId,
      @HiveField(3) String operation,
      @HiveField(4) Map<String, dynamic> payload,
      @HiveField(5) String status,
      @HiveField(6) DateTime createdAt});
}

/// @nodoc
class _$SyncTaskCopyWithImpl<$Res, $Val extends SyncTask>
    implements $SyncTaskCopyWith<$Res> {
  _$SyncTaskCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? collection = null,
    Object? documentId = null,
    Object? operation = null,
    Object? payload = null,
    Object? status = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      collection: null == collection
          ? _value.collection
          : collection // ignore: cast_nullable_to_non_nullable
              as String,
      documentId: null == documentId
          ? _value.documentId
          : documentId // ignore: cast_nullable_to_non_nullable
              as String,
      operation: null == operation
          ? _value.operation
          : operation // ignore: cast_nullable_to_non_nullable
              as String,
      payload: null == payload
          ? _value.payload
          : payload // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SyncTaskImplCopyWith<$Res>
    implements $SyncTaskCopyWith<$Res> {
  factory _$$SyncTaskImplCopyWith(
          _$SyncTaskImpl value, $Res Function(_$SyncTaskImpl) then) =
      __$$SyncTaskImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String collection,
      @HiveField(2) String documentId,
      @HiveField(3) String operation,
      @HiveField(4) Map<String, dynamic> payload,
      @HiveField(5) String status,
      @HiveField(6) DateTime createdAt});
}

/// @nodoc
class __$$SyncTaskImplCopyWithImpl<$Res>
    extends _$SyncTaskCopyWithImpl<$Res, _$SyncTaskImpl>
    implements _$$SyncTaskImplCopyWith<$Res> {
  __$$SyncTaskImplCopyWithImpl(
      _$SyncTaskImpl _value, $Res Function(_$SyncTaskImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? collection = null,
    Object? documentId = null,
    Object? operation = null,
    Object? payload = null,
    Object? status = null,
    Object? createdAt = null,
  }) {
    return _then(_$SyncTaskImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      collection: null == collection
          ? _value.collection
          : collection // ignore: cast_nullable_to_non_nullable
              as String,
      documentId: null == documentId
          ? _value.documentId
          : documentId // ignore: cast_nullable_to_non_nullable
              as String,
      operation: null == operation
          ? _value.operation
          : operation // ignore: cast_nullable_to_non_nullable
              as String,
      payload: null == payload
          ? _value._payload
          : payload // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
@HiveType(typeId: 4, adapterName: 'SyncTaskAdapter')
class _$SyncTaskImpl implements _SyncTask {
  const _$SyncTaskImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.collection,
      @HiveField(2) required this.documentId,
      @HiveField(3) required this.operation,
      @HiveField(4) required final Map<String, dynamic> payload,
      @HiveField(5) required this.status,
      @HiveField(6) required this.createdAt})
      : _payload = payload;

  factory _$SyncTaskImpl.fromJson(Map<String, dynamic> json) =>
      _$$SyncTaskImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String collection;
  @override
  @HiveField(2)
  final String documentId;
  @override
  @HiveField(3)
  final String operation;
// 'create', 'update', 'delete'
  final Map<String, dynamic> _payload;
// 'create', 'update', 'delete'
  @override
  @HiveField(4)
  Map<String, dynamic> get payload {
    if (_payload is EqualUnmodifiableMapView) return _payload;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_payload);
  }

  @override
  @HiveField(5)
  final String status;
// 'pending', 'completed', 'failed'
  @override
  @HiveField(6)
  final DateTime createdAt;

  @override
  String toString() {
    return 'SyncTask(id: $id, collection: $collection, documentId: $documentId, operation: $operation, payload: $payload, status: $status, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncTaskImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.collection, collection) ||
                other.collection == collection) &&
            (identical(other.documentId, documentId) ||
                other.documentId == documentId) &&
            (identical(other.operation, operation) ||
                other.operation == operation) &&
            const DeepCollectionEquality().equals(other._payload, _payload) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      collection,
      documentId,
      operation,
      const DeepCollectionEquality().hash(_payload),
      status,
      createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SyncTaskImplCopyWith<_$SyncTaskImpl> get copyWith =>
      __$$SyncTaskImplCopyWithImpl<_$SyncTaskImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SyncTaskImplToJson(
      this,
    );
  }
}

abstract class _SyncTask implements SyncTask {
  const factory _SyncTask(
      {@HiveField(0) required final String id,
      @HiveField(1) required final String collection,
      @HiveField(2) required final String documentId,
      @HiveField(3) required final String operation,
      @HiveField(4) required final Map<String, dynamic> payload,
      @HiveField(5) required final String status,
      @HiveField(6) required final DateTime createdAt}) = _$SyncTaskImpl;

  factory _SyncTask.fromJson(Map<String, dynamic> json) =
      _$SyncTaskImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get collection;
  @override
  @HiveField(2)
  String get documentId;
  @override
  @HiveField(3)
  String get operation;
  @override // 'create', 'update', 'delete'
  @HiveField(4)
  Map<String, dynamic> get payload;
  @override
  @HiveField(5)
  String get status;
  @override // 'pending', 'completed', 'failed'
  @HiveField(6)
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$SyncTaskImplCopyWith<_$SyncTaskImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
