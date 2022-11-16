import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv/tv_detail.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';

class GetTVShowDetail {
  final TVRepository repository;

  GetTVShowDetail({required this.repository});

  Future<Either<Failure, TVDetail>> execute(int id) {
    return repository.getTVShowDetail(id);
  }
}
