import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv/season_detail.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';

class GetTVSeasonDetail {
  final TVRepository repository;

  GetTVSeasonDetail({required this.repository});

  Future<Either<Failure, SeasonDetail>> execute(int tvId, int seasonNumber) {
    return repository.getSeasonDetail(tvId, seasonNumber);
  }
}
