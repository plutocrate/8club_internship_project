import 'package:json_annotation/json_annotation.dart';

part 'experience.model.g.dart';

@JsonSerializable()
class Experience {
  final int id;
  final String name;
  final String tagline;
  final String description;

  @JsonKey(name: 'image_url')
  final String imageUrl;

  @JsonKey(name: 'icon_url')
  final String iconUrl;

  final int order;

  const Experience({
    required this.id,
    required this.name,
    required this.tagline,
    required this.description,
    required this.imageUrl,
    required this.iconUrl,
    required this.order,
  });

  factory Experience.fromJson(Map<String, dynamic> json) =>
      _$ExperienceFromJson(json);

  Map<String, dynamic> toJson() => _$ExperienceToJson(this);
}
