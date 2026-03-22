// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'node_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ChartNode _$ChartNodeFromJson(Map<String, dynamic> json) {
  return _ChartNode.fromJson(json);
}

/// @nodoc
mixin _$ChartNode {
  String get id => throw _privateConstructorUsedError;
  NodeType get type => throw _privateConstructorUsedError;
  double get x => throw _privateConstructorUsedError;
  double get y => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  double get width => throw _privateConstructorUsedError;
  double get height => throw _privateConstructorUsedError;
  double get fontSize => throw _privateConstructorUsedError;

  /// Serializes this ChartNode to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChartNode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChartNodeCopyWith<ChartNode> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChartNodeCopyWith<$Res> {
  factory $ChartNodeCopyWith(ChartNode value, $Res Function(ChartNode) then) =
      _$ChartNodeCopyWithImpl<$Res, ChartNode>;
  @useResult
  $Res call({
    String id,
    NodeType type,
    double x,
    double y,
    String text,
    double width,
    double height,
    double fontSize,
  });
}

/// @nodoc
class _$ChartNodeCopyWithImpl<$Res, $Val extends ChartNode>
    implements $ChartNodeCopyWith<$Res> {
  _$ChartNodeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChartNode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? x = null,
    Object? y = null,
    Object? text = null,
    Object? width = null,
    Object? height = null,
    Object? fontSize = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as NodeType,
            x: null == x
                ? _value.x
                : x // ignore: cast_nullable_to_non_nullable
                      as double,
            y: null == y
                ? _value.y
                : y // ignore: cast_nullable_to_non_nullable
                      as double,
            text: null == text
                ? _value.text
                : text // ignore: cast_nullable_to_non_nullable
                      as String,
            width: null == width
                ? _value.width
                : width // ignore: cast_nullable_to_non_nullable
                      as double,
            height: null == height
                ? _value.height
                : height // ignore: cast_nullable_to_non_nullable
                      as double,
            fontSize: null == fontSize
                ? _value.fontSize
                : fontSize // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ChartNodeImplCopyWith<$Res>
    implements $ChartNodeCopyWith<$Res> {
  factory _$$ChartNodeImplCopyWith(
    _$ChartNodeImpl value,
    $Res Function(_$ChartNodeImpl) then,
  ) = __$$ChartNodeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    NodeType type,
    double x,
    double y,
    String text,
    double width,
    double height,
    double fontSize,
  });
}

/// @nodoc
class __$$ChartNodeImplCopyWithImpl<$Res>
    extends _$ChartNodeCopyWithImpl<$Res, _$ChartNodeImpl>
    implements _$$ChartNodeImplCopyWith<$Res> {
  __$$ChartNodeImplCopyWithImpl(
    _$ChartNodeImpl _value,
    $Res Function(_$ChartNodeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChartNode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? x = null,
    Object? y = null,
    Object? text = null,
    Object? width = null,
    Object? height = null,
    Object? fontSize = null,
  }) {
    return _then(
      _$ChartNodeImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as NodeType,
        x: null == x
            ? _value.x
            : x // ignore: cast_nullable_to_non_nullable
                  as double,
        y: null == y
            ? _value.y
            : y // ignore: cast_nullable_to_non_nullable
                  as double,
        text: null == text
            ? _value.text
            : text // ignore: cast_nullable_to_non_nullable
                  as String,
        width: null == width
            ? _value.width
            : width // ignore: cast_nullable_to_non_nullable
                  as double,
        height: null == height
            ? _value.height
            : height // ignore: cast_nullable_to_non_nullable
                  as double,
        fontSize: null == fontSize
            ? _value.fontSize
            : fontSize // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ChartNodeImpl extends _ChartNode {
  const _$ChartNodeImpl({
    required this.id,
    required this.type,
    required this.x,
    required this.y,
    this.text = '',
    this.width = 140.0,
    this.height = 80.0,
    this.fontSize = 14.0,
  }) : super._();

  factory _$ChartNodeImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChartNodeImplFromJson(json);

  @override
  final String id;
  @override
  final NodeType type;
  @override
  final double x;
  @override
  final double y;
  @override
  @JsonKey()
  final String text;
  @override
  @JsonKey()
  final double width;
  @override
  @JsonKey()
  final double height;
  @override
  @JsonKey()
  final double fontSize;

  @override
  String toString() {
    return 'ChartNode(id: $id, type: $type, x: $x, y: $y, text: $text, width: $width, height: $height, fontSize: $fontSize)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChartNodeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.x, x) || other.x == x) &&
            (identical(other.y, y) || other.y == y) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.fontSize, fontSize) ||
                other.fontSize == fontSize));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, type, x, y, text, width, height, fontSize);

  /// Create a copy of ChartNode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChartNodeImplCopyWith<_$ChartNodeImpl> get copyWith =>
      __$$ChartNodeImplCopyWithImpl<_$ChartNodeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChartNodeImplToJson(this);
  }
}

abstract class _ChartNode extends ChartNode {
  const factory _ChartNode({
    required final String id,
    required final NodeType type,
    required final double x,
    required final double y,
    final String text,
    final double width,
    final double height,
    final double fontSize,
  }) = _$ChartNodeImpl;
  const _ChartNode._() : super._();

  factory _ChartNode.fromJson(Map<String, dynamic> json) =
      _$ChartNodeImpl.fromJson;

  @override
  String get id;
  @override
  NodeType get type;
  @override
  double get x;
  @override
  double get y;
  @override
  String get text;
  @override
  double get width;
  @override
  double get height;
  @override
  double get fontSize;

  /// Create a copy of ChartNode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChartNodeImplCopyWith<_$ChartNodeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
