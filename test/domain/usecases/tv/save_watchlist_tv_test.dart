import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/tv/save_watchlist_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late SaveWatchlistTV usecase;
  late MockTVRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockTVRepository();
    usecase = SaveWatchlistTV(repository: mockMovieRepository);
  });

  group('SaveWatchlistTV Tests', () {
    test(
        'should add watchlist tv shows from repository when execute function is called',
        () async {
      // arrange
      when(mockMovieRepository.saveWatchlistTV(testTVDetail))
          .thenAnswer((_) async => Right('Added TV from Watchlist'));
      // act
      final result = await usecase.execute(testTVDetail);
      // assert
      expect(result, Right('Added TV from Watchlist'));
    });
  });
}
