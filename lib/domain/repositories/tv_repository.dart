import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv/season_detail.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/entities/tv/tv_detail.dart';

abstract class TVRepository {
  Future<Either<Failure, List<TV>>> getOnTheAirTVShows();
  Future<Either<Failure, List<TV>>> getPopularTVShows();
  Future<Either<Failure, List<TV>>> getTopRatedTVShows();
  Future<Either<Failure, TVDetail>> getTVShowDetail(int id);
  Future<Either<Failure, List<TV>>> getTVShowRecommendations(int id);
  Future<Either<Failure, List<TV>>> searchTVShows(String query);
  Future<Either<Failure, String>> saveWatchlistTV(TVDetail tv);
  Future<Either<Failure, String>> removeWatchlistTV(TVDetail tv);
  Future<bool> isAddedToWatchlistTV(int id);
  Future<Either<Failure, List<TV>>> getWatchlistTVShows();
  Future<Either<Failure, SeasonDetail>> getSeasonDetail(
      int tvId, int seasonNumber);
}
