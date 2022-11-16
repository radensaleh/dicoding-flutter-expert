import 'package:ditonton/domain/repositories/movie_repository.dart';

class CheckConnection {
  final MovieRepository repository;

  CheckConnection(this.repository);

  Future<bool> execute() async {
    return repository.isConnected();
  }
}
