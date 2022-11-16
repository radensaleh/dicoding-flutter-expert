import 'dart:convert';

import 'package:ditonton/data/models/tv/tv_model.dart';
import 'package:equatable/equatable.dart';

class TVResponse extends Equatable {
  TVResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  final int page;
  final List<TVModel> results;
  final int totalPages;
  final int totalResults;

  factory TVResponse.fromRawJson(String str) =>
      TVResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TVResponse.fromJson(Map<String, dynamic> json) => TVResponse(
        page: json["page"],
        results: List<TVModel>.from((json['results'] as List)
            .map((x) => TVModel.fromJson(x))
            .where((element) => element.posterPath != null)),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
        "total_pages": totalPages,
        "total_results": totalResults,
      };

  @override
  List<Object?> get props => [
        page,
        results,
        totalPages,
        totalResults,
      ];
}
