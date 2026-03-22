// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'node_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChartNodeImpl _$$ChartNodeImplFromJson(Map<String, dynamic> json) =>
    _$ChartNodeImpl(
      id: json['id'] as String,
      type: $enumDecode(_$NodeTypeEnumMap, json['type']),
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      text: json['text'] as String? ?? '',
      width: (json['width'] as num?)?.toDouble() ?? 140.0,
      height: (json['height'] as num?)?.toDouble() ?? 80.0,
      fontSize: (json['fontSize'] as num?)?.toDouble() ?? 14.0,
    );

Map<String, dynamic> _$$ChartNodeImplToJson(_$ChartNodeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$NodeTypeEnumMap[instance.type]!,
      'x': instance.x,
      'y': instance.y,
      'text': instance.text,
      'width': instance.width,
      'height': instance.height,
      'fontSize': instance.fontSize,
    };

const _$NodeTypeEnumMap = {
  NodeType.subjective: 'subjective',
  NodeType.objective: 'objective',
  NodeType.midpoint: 'midpoint',
};
