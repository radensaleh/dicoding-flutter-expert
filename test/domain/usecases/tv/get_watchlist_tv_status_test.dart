import 'package:ditonton/domain/usecases/tv/get_watchlist_tv_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetWatchlistTVStatus usecase;
  late MockTVRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockTVRepository();
    usecase = GetWatchlistTVStatus(repository: mockMovieRepository);
  });

  group('GetWatchlistTVStatus Tests', () {
    test(
        'should get watchlist status from repository when execute function is called',
        () async {
      // arrange
      when(mockMovieRepository.isAddedToWatchlistTV(1))
          .thenAnswer((_) async => true);
      // act
      final result = await usecase.execute(1);
      // assert
      expect(result, true);
    });
  });
}
