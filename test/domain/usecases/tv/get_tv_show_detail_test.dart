import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_show_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetTVShowDetail usecase;
  late MockTVRepository mockTVRepository;

  setUp(() {
    mockTVRepository = MockTVRepository();
    usecase = GetTVShowDetail(repository: mockTVRepository);
  });

  final tvId = 1;

  group('GetTVShowDetail Tests', () {
    test(
        'should get detail tv shows the repository when execute function is called',
        () async {
      // arrange
      when(mockTVRepository.getTVShowDetail(tvId))
          .thenAnswer((_) async => Right(testTVDetail));
      // act
      final result = await usecase.execute(tvId);
      // assert
      expect(result, Right(testTVDetail));
    });
  });
}
