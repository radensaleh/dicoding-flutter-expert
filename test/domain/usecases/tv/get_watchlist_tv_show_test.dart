import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_watchlist_tv_shows.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetWatchlistTVShows usecase;
  late MockTVRepository mockTVRepository;

  setUp(() {
    mockTVRepository = MockTVRepository();
    usecase = GetWatchlistTVShows(repository: mockTVRepository);
  });

  final tTVShows = <TV>[];

  group('GetWatchlistTVShows Tests', () {
    test(
        'should get list of watchlist tv shows the repository when execute function is called',
        () async {
      // arrange
      when(mockTVRepository.getWatchlistTVShows())
          .thenAnswer((_) async => Right(tTVShows));
      // act
      final result = await usecase.execute();
      // assert
      expect(result, Right(tTVShows));
    });
  });
}
