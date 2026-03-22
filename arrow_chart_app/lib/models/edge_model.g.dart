// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edge_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChartEdgeImpl _$$ChartEdgeImplFromJson(Map<String, dynamic> json) =>
    _$ChartEdgeImpl(
      id: json['id'] as String,
      sourceId: json['sourceId'] as String,
      targetId: json['targetId'] as String,
      relation: $enumDecode(_$EdgeRelationEnumMap, json['relation']),
    );

Map<String, dynamic> _$$ChartEdgeImplToJson(_$ChartEdgeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sourceId': instance.sourceId,
      'targetId': instance.targetId,
      'relation': _$EdgeRelationEnumMap[instance.relation]!,
    };

const _$EdgeRelationEnumMap = {
  EdgeRelation.causeEffect: 'cause_effect',
  EdgeRelation.paradox: 'paradox',
  EdgeRelation.connection: 'connection',
};
