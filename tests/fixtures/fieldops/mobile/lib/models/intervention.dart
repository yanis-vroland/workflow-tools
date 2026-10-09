import 'package:json_annotation/json_annotation.dart';

part 'intervention.g.dart';

/// Intervention telle que vue par le technicien.
@JsonSerializable()
class Intervention {
  Intervention({
    required this.id,
    required this.address,
    required this.startsAt,
    required this.status,
    this.report,
  });

  final int id;
  final String address;
  @JsonKey(name: 'starts_at')
  final DateTime startsAt;
  final String status;
  final String? report;

  factory Intervention.fromJson(Map<String, dynamic> json) => _$InterventionFromJson(json);

  Map<String, dynamic> toJson() => _$InterventionToJson(this);
}
