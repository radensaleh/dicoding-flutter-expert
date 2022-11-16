import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';

class GetTVShowRecommendations {
  final TVRepository repository;

  GetTVShowRecommendations({required this.repository});

  Future<Either<Failure, List<TV>>> execute(int id) {
    return repository.getTVShowRecommendations(id);
  }
}
