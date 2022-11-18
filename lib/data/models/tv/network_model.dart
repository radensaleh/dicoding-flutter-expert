import 'package:equatable/equatable.dart';

class NetworkModel extends Equatable {
  NetworkModel({
    required this.id,
    required this.name,
    required this.logoPath,
    required this.originCountry,
  });

  final int id;
  final String? name;
  final String? logoPath;
  final String? originCountry;

  factory NetworkModel.fromJson(Map<String, dynamic> json) => NetworkModel(
        id: json["id"],
        name: json["name"],
        logoPath: json["logo_path"],
        originCountry: json["origin_country"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "logo_path": logoPath,
        "origin_country": originCountry,
      };

  @override
  List<Object?> get props => [
        id,
        name,
        logoPath,
        originCountry,
      ];
}
