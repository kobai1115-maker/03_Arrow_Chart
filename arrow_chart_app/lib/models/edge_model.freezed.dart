// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'edge_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ChartEdge _$ChartEdgeFromJson(Map<String, dynamic> json) {
  return _ChartEdge.fromJson(json);
}

/// @nodoc
mixin _$ChartEdge {
  String get id => throw _privateConstructorUsedError;
  String get sourceId => throw _privateConstructorUsedError;
  String get targetId => throw _privateConstructorUsedError;
  EdgeRelation get relation => throw _privateConstructorUsedError;

  /// Serializes this ChartEdge to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChartEdge
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChartEdgeCopyWith<ChartEdge> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChartEdgeCopyWith<$Res> {
  factory $ChartEdgeCopyWith(ChartEdge value, $Res Function(ChartEdge) then) =
      _$ChartEdgeCopyWithImpl<$Res, ChartEdge>;
  @useResult
  $Res call({
    String id,
    String sourceId,
    String targetId,
    EdgeRelation relation,
  });
}

/// @nodoc
class _$ChartEdgeCopyWithImpl<$Res, $Val extends ChartEdge>
    implements $ChartEdgeCopyWith<$Res> {
  _$ChartEdgeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChartEdge
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sourceId = null,
    Object? targetId = null,
    Object? relation = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            sourceId: null == sourceId
                ? _value.sourceId
                : sourceId // ignore: cast_nullable_to_non_nullable
                      as String,
            targetId: null == targetId
                ? _value.targetId
                : targetId // ignore: cast_nullable_to_non_nullable
                      as String,
            relation: null == relation
                ? _value.relation
                : relation // ignore: cast_nullable_to_non_nullable
                      as EdgeRelation,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ChartEdgeImplCopyWith<$Res>
    implements $ChartEdgeCopyWith<$Res> {
  factory _$$ChartEdgeImplCopyWith(
    _$ChartEdgeImpl value,
    $Res Function(_$ChartEdgeImpl) then,
  ) = __$$ChartEdgeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String sourceId,
    String targetId,
    EdgeRelation relation,
  });
}

/// @nodoc
class __$$ChartEdgeImplCopyWithImpl<$Res>
    extends _$ChartEdgeCopyWithImpl<$Res, _$ChartEdgeImpl>
    implements _$$ChartEdgeImplCopyWith<$Res> {
  __$$ChartEdgeImplCopyWithImpl(
    _$ChartEdgeImpl _value,
    $Res Function(_$ChartEdgeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChartEdge
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sourceId = null,
    Object? targetId = null,
    Object? relation = null,
  }) {
    return _then(
      _$ChartEdgeImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        sourceId: null == sourceId
            ? _value.sourceId
            : sourceId // ignore: cast_nullable_to_non_nullable
                  as String,
        targetId: null == targetId
            ? _value.targetId
            : targetId // ignore: cast_nullable_to_non_nullable
                  as String,
        relation: null == relation
            ? _value.relation
            : relation // ignore: cast_nullable_to_non_nullable
                  as EdgeRelation,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ChartEdgeImpl implements _ChartEdge {
  const _$ChartEdgeImpl({
    required this.id,
    required this.sourceId,
    required this.targetId,
    required this.relation,
  });

  factory _$ChartEdgeImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChartEdgeImplFromJson(json);

  @override
  final String id;
  @override
  final String sourceId;
  @override
  final String targetId;
  @override
  final EdgeRelation relation;

  @override
  String toString() {
    return 'ChartEdge(id: $id, sourceId: $sourceId, targetId: $targetId, relation: $relation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChartEdgeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sourceId, sourceId) ||
                other.sourceId == sourceId) &&
            (identical(other.targetId, targetId) ||
                other.targetId == targetId) &&
            (identical(other.relation, relation) ||
                other.relation == relation));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, sourceId, targetId, relation);

  /// Create a copy of ChartEdge
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChartEdgeImplCopyWith<_$ChartEdgeImpl> get copyWith =>
      __$$ChartEdgeImplCopyWithImpl<_$ChartEdgeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChartEdgeImplToJson(this);
  }
}

abstract class _ChartEdge implements ChartEdge {
  const factory _ChartEdge({
    required final String id,
    required final String sourceId,
    required final String targetId,
    required final EdgeRelation relation,
  }) = _$ChartEdgeImpl;

  factory _ChartEdge.fromJson(Map<String, dynamic> json) =
      _$ChartEdgeImpl.fromJson;

  @override
  String get id;
  @override
  String get sourceId;
  @override
  String get targetId;
  @override
  EdgeRelation get relation;

  /// Create a copy of ChartEdge
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChartEdgeImplCopyWith<_$ChartEdgeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
