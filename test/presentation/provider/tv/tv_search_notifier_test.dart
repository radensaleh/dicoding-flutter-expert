import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/search_tv_shows.dart';
import 'package:ditonton/presentation/provider/tv/tv_search_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_search_notifier_test.mocks.dart';

@GenerateMocks([SearchTVShows])
void main() {
  late TVSearchNotifier provider;
  late MockSearchTVShows mockSearchTVShows;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockSearchTVShows = MockSearchTVShows();
    provider = TVSearchNotifier(searchTVShows: mockSearchTVShows)
      ..addListener(() {
        listenerCallCount += 1;
      });
  });

  final tTVShow = TV(
    backdropPath: 'backdropPath',
    firstAirDate: null,
    genreIds: [1, 2, 3],
    id: 1,
    name: 'name',
    originCountry: ['originCountry'],
    originalLanguage: 'originalLanguage',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 21.1,
    posterPath: 'posterPath',
    voteAverage: 11.2,
    voteCount: 22,
  );

  final tTVList = <TV>[tTVShow];
  final tQuery = 'spiderman';

  group('search tv shows', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockSearchTVShows.execute(tQuery))
          .thenAnswer((_) async => Right(tTVList));
      // act
      provider.fetchTVSearch(tQuery);
      // fetchTVSearch
      expect(provider.state, RequestState.loading);
    });

    test('should change search result data when data is gotten successfully',
        () async {
      // arrange
      when(mockSearchTVShows.execute(tQuery))
          .thenAnswer((_) async => Right(tTVList));
      // act
      await provider.fetchTVSearch(tQuery);
      // assert
      expect(provider.state, RequestState.loaded);
      expect(provider.searchResult, tTVList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockSearchTVShows.execute(tQuery))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchTVSearch(tQuery);
      // assert
      expect(provider.state, RequestState.error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
