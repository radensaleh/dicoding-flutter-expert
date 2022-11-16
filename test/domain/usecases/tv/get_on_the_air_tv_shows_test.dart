import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_on_the_air_tv_shows.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetOnTheAirTVShows usecase;
  late MockTVRepository mockTVRepository;

  setUp(() {
    mockTVRepository = MockTVRepository();
    usecase = GetOnTheAirTVShows(repository: mockTVRepository);
  });

  final tTVShows = <TV>[];

  group('GetOnTheAirTVShows Tests', () {
    test(
        'should get list of on the air tv shows from the repository when execute function is called',
        () async {
      // arrange
      when(mockTVRepository.getOnTheAirTVShows())
          .thenAnswer((_) async => Right(tTVShows));
      // act
      final result = await usecase.execute();
      // assert
      expect(result, Right(tTVShows));
    });
  });
}
