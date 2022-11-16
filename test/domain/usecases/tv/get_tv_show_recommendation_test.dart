import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_show_recommendations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetTVShowRecommendations usecase;
  late MockTVRepository mockTVRepository;

  setUp(() {
    mockTVRepository = MockTVRepository();
    usecase = GetTVShowRecommendations(repository: mockTVRepository);
  });

  final tvId = 1;
  final tTVShows = <TV>[];

  group('GetTVShowRecommendations Tests', () {
    test(
        'should get list of recommendations tv shows the repository when execute function is called',
        () async {
      // arrange
      when(mockTVRepository.getTVShowRecommendations(tvId))
          .thenAnswer((_) async => Right(tTVShows));
      // act
      final result = await usecase.execute(tvId);
      // assert
      expect(result, Right(tTVShows));
    });
  });
}
