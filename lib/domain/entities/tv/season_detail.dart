import 'package:ditonton/domain/entities/tv/episode.dart';
import 'package:equatable/equatable.dart';

class SeasonDetail extends Equatable {
  SeasonDetail({
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
  final List<Episode> episodes;
  final String name;
  final String overview;
  final int seasonDetailResponseId;
  final String? posterPath;
  final int seasonNumber;

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
