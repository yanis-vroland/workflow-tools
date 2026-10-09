// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'intervention.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Intervention _$InterventionFromJson(Map<String, dynamic> json) => Intervention(
      id: json['id'] as int,
      address: json['address'] as String,
      startsAt: DateTime.parse(json['starts_at'] as String),
      status: json['status'] as String,
      report: json['report'] as String?,
    );

Map<String, dynamic> _$InterventionToJson(Intervention instance) =>
    <String, dynamic>{
      'id': instance.id,
      'address': instance.address,
      'starts_at': instance.startsAt.toIso8601String(),
      'status': instance.status,
      'report': instance.report,
    };
