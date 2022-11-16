import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/search_tv_shows.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late SearchTVShows usecase;
  late MockTVRepository mockTVRepository;

  setUp(() {
    mockTVRepository = MockTVRepository();
    usecase = SearchTVShows(repository: mockTVRepository);
  });

  final tTVShows = <TV>[];
  final tQuery = 'Spiderman';

  group('SearchTVShows Tests', () {
    test('should get list of tv shows from the repository', () async {
      // arrange
      when(mockTVRepository.searchTVShows(tQuery))
          .thenAnswer((_) async => Right(tTVShows));
      // act
      final result = await usecase.execute(tQuery);
      // assert
      expect(result, Right(tTVShows));
    });
  });
}
