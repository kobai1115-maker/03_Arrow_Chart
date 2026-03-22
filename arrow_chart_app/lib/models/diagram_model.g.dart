// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diagram_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DiagramImpl _$$DiagramImplFromJson(Map<String, dynamic> json) =>
    _$DiagramImpl(
      id: json['id'] as String,
      title: json['title'] as String? ?? '新規アローチャート',
      nodes:
          (json['nodes'] as List<dynamic>?)
              ?.map((e) => ChartNode.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      edges:
          (json['edges'] as List<dynamic>?)
              ?.map((e) => ChartEdge.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$DiagramImplToJson(_$DiagramImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'nodes': instance.nodes,
      'edges': instance.edges,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
