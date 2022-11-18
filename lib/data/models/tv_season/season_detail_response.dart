import 'package:ditonton/data/models/tv_season/episode_model.dart';
import 'package:ditonton/domain/entities/tv/season_detail.dart';
import 'package:equatable/equatable.dart';

class SeasonDetailResponse extends Equatable {
  SeasonDetailResponse({
    required this.id,
    required this.airDate,
    required this.episodes,
    required this.name,
    required this.overview,
    required this.seasonDetailResponseId,
    required this.posterPath,
    required this.seasonNumber,
  });

  final String id;
  final dynamic airDate;
  final List<EpisodeModel> episodes;
  final String name;
  final String overview;
  final int seasonDetailResponseId;
  final String? posterPath;
  final int seasonNumber;

  factory SeasonDetailResponse.fromJson(Map<String, dynamic> json) =>
      SeasonDetailResponse(
        id: json["_id"],
        airDate: json["air_date"],
        episodes: List<EpisodeModel>.from(
            json["episodes"].map((x) => EpisodeModel.fromJson(x))),
        name: json["name"],
        overview: json["overview"],
        seasonDetailResponseId: json["id"],
        posterPath: json["poster_path"],
        seasonNumber: json["season_number"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "air_date": airDate,
        "episodes": List<dynamic>.from(episodes.map((x) => x.toJson())),
        "name": name,
        "overview": overview,
        "id": seasonDetailResponseId,
        "poster_path": posterPath,
        "season_number": seasonNumber,
      };

  SeasonDetail toEntity() {
    return SeasonDetail(
      id: this.id,
      airDate: this.airDate,
      episodes: this.episodes.map((eps) => eps.toEntity()).toList(),
      name: this.name,
      overview: this.overview,
      seasonDetailResponseId: this.seasonDetailResponseId,
      posterPath: this.posterPath,
      seasonNumber: this.seasonNumber,
    );
  }

  @override
  List<Object?> get props => [
        id,
        airDate,
        episodes,
        name,
        overview,
        seasonDetailResponseId,
        posterPath,
        seasonNumber,
      ];
}
