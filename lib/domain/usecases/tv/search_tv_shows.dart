import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';

class SearchTVShows {
  final TVRepository repository;

  SearchTVShows({required this.repository});

  Future<Either<Failure, List<TV>>> execute(String query) {
    return repository.searchTVShows(query);
  }
}
