import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_season_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetTVSeasonDetail usecase;
  late MockTVRepository mockTVRepository;

  setUp(() {
    mockTVRepository = MockTVRepository();
    usecase = GetTVSeasonDetail(repository: mockTVRepository);
  });

  final tvId = 1;
  final seasonNumber = 2;

  group('GetTVSeasonDetail Tests', () {
    test(
        'should get detail season tv shows the repository when execute function is called',
        () async {
      // arrange
      when(mockTVRepository.getSeasonDetail(tvId, seasonNumber))
          .thenAnswer((_) async => Right(testTVSeasonDetail));
      // act
      final result = await usecase.execute(tvId, seasonNumber);
      // assert
      expect(result, Right(testTVSeasonDetail));
    });
  });
}
