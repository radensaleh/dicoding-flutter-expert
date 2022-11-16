import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/tv/remove_watchlist_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late RemoveWatchlistTV usecase;
  late MockTVRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockTVRepository();
    usecase = RemoveWatchlistTV(repository: mockMovieRepository);
  });

  group('RemoveWatchlistTV Tests', () {
    test(
        'should remove watchlist tv shows from repository when execute function is called',
        () async {
      // arrange
      when(mockMovieRepository.removeWatchlistTV(testTVDetail))
          .thenAnswer((_) async => Right('Removed TV from Watchlist'));
      // act
      final result = await usecase.execute(testTVDetail);
      // assert
      expect(result, Right('Removed TV from Watchlist'));
    });
  });
}
