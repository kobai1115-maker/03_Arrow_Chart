// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'diagram_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Diagram _$DiagramFromJson(Map<String, dynamic> json) {
  return _Diagram.fromJson(json);
}

/// @nodoc
mixin _$Diagram {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  List<ChartNode> get nodes => throw _privateConstructorUsedError;
  List<ChartEdge> get edges => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Diagram to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Diagram
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DiagramCopyWith<Diagram> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DiagramCopyWith<$Res> {
  factory $DiagramCopyWith(Diagram value, $Res Function(Diagram) then) =
      _$DiagramCopyWithImpl<$Res, Diagram>;
  @useResult
  $Res call({
    String id,
    String title,
    List<ChartNode> nodes,
    List<ChartEdge> edges,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$DiagramCopyWithImpl<$Res, $Val extends Diagram>
    implements $DiagramCopyWith<$Res> {
  _$DiagramCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Diagram
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? nodes = null,
    Object? edges = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            nodes: null == nodes
                ? _value.nodes
                : nodes // ignore: cast_nullable_to_non_nullable
                      as List<ChartNode>,
            edges: null == edges
                ? _value.edges
                : edges // ignore: cast_nullable_to_non_nullable
                      as List<ChartEdge>,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DiagramImplCopyWith<$Res> implements $DiagramCopyWith<$Res> {
  factory _$$DiagramImplCopyWith(
    _$DiagramImpl value,
    $Res Function(_$DiagramImpl) then,
  ) = __$$DiagramImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    List<ChartNode> nodes,
    List<ChartEdge> edges,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$DiagramImplCopyWithImpl<$Res>
    extends _$DiagramCopyWithImpl<$Res, _$DiagramImpl>
    implements _$$DiagramImplCopyWith<$Res> {
  __$$DiagramImplCopyWithImpl(
    _$DiagramImpl _value,
    $Res Function(_$DiagramImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Diagram
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? nodes = null,
    Object? edges = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$DiagramImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        nodes: null == nodes
            ? _value._nodes
            : nodes // ignore: cast_nullable_to_non_nullable
                  as List<ChartNode>,
        edges: null == edges
            ? _value._edges
            : edges // ignore: cast_nullable_to_non_nullable
                  as List<ChartEdge>,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DiagramImpl extends _Diagram {
  const _$DiagramImpl({
    required this.id,
    this.title = '新規アローチャート',
    final List<ChartNode> nodes = const [],
    final List<ChartEdge> edges = const [],
    this.createdAt,
    this.updatedAt,
  }) : _nodes = nodes,
       _edges = edges,
       super._();

  factory _$DiagramImpl.fromJson(Map<String, dynamic> json) =>
      _$$DiagramImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey()
  final String title;
  final List<ChartNode> _nodes;
  @override
  @JsonKey()
  List<ChartNode> get nodes {
    if (_nodes is EqualUnmodifiableListView) return _nodes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_nodes);
  }

  final List<ChartEdge> _edges;
  @override
  @JsonKey()
  List<ChartEdge> get edges {
    if (_edges is EqualUnmodifiableListView) return _edges;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_edges);
  }

  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Diagram(id: $id, title: $title, nodes: $nodes, edges: $edges, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DiagramImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            const DeepCollectionEquality().equals(other._nodes, _nodes) &&
            const DeepCollectionEquality().equals(other._edges, _edges) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    const DeepCollectionEquality().hash(_nodes),
    const DeepCollectionEquality().hash(_edges),
    createdAt,
    updatedAt,
  );

  /// Create a copy of Diagram
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DiagramImplCopyWith<_$DiagramImpl> get copyWith =>
      __$$DiagramImplCopyWithImpl<_$DiagramImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DiagramImplToJson(this);
  }
}

abstract class _Diagram extends Diagram {
  const factory _Diagram({
    required final String id,
    final String title,
    final List<ChartNode> nodes,
    final List<ChartEdge> edges,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$DiagramImpl;
  const _Diagram._() : super._();

  factory _Diagram.fromJson(Map<String, dynamic> json) = _$DiagramImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  List<ChartNode> get nodes;
  @override
  List<ChartEdge> get edges;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of Diagram
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DiagramImplCopyWith<_$DiagramImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
