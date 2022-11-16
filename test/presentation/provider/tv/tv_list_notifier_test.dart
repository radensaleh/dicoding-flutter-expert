import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_on_the_air_tv_shows.dart';
import 'package:ditonton/domain/usecases/tv/get_popular_tv_shows.dart';
import 'package:ditonton/domain/usecases/tv/get_top_rated_tv_shows.dart';
import 'package:ditonton/presentation/provider/tv/tv_list_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_list_notifier_test.mocks.dart';

@GenerateMocks([
  GetOnTheAirTVShows,
  GetPopularTVShows,
  GetTopRatedTVShows,
])
void main() {
  late TVListNotifier provider;
  late MockGetOnTheAirTVShows mockGetOnTheAirTVShows;
  late MockGetPopularTVShows mockGetPopularTVShows;
  late MockGetTopRatedTVShows mockGetTopRatedTVShows;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetOnTheAirTVShows = MockGetOnTheAirTVShows();
    mockGetPopularTVShows = MockGetPopularTVShows();
    mockGetTopRatedTVShows = MockGetTopRatedTVShows();
    provider = TVListNotifier(
      getOnTheAirTVShows: mockGetOnTheAirTVShows,
      getPopularTVShows: mockGetPopularTVShows,
      getTopRatedTVShows: mockGetTopRatedTVShows,
    )..addListener(() {
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

  group('on the air TV shows', () {
    test('initialState should be Empty', () {
      expect(provider.onTheAirTVState, equals(RequestState.empty));
    });

    test('should get data from the usecase', () async {
      // arrange
      when(mockGetOnTheAirTVShows.execute())
          .thenAnswer((_) async => Right(tTVList));
      // act
      provider.fetchOnTheAirTVShows();
      // assert
      verify(mockGetOnTheAirTVShows.execute());
    });

    test('should change state to Loading when usecase is called', () {
      // arrange
      when(mockGetOnTheAirTVShows.execute())
          .thenAnswer((_) async => Right(tTVList));
      // act
      provider.fetchOnTheAirTVShows();
      // assert
      expect(provider.onTheAirTVState, RequestState.loading);
    });

    test('should change tv shows when data is gotten successfully', () async {
      // arrange
      when(mockGetOnTheAirTVShows.execute())
          .thenAnswer((_) async => Right(tTVList));
      // act
      await provider.fetchOnTheAirTVShows();
      // assert
      expect(provider.onTheAirTVState, RequestState.loaded);
      expect(provider.onTheAirTVShows, tTVList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetOnTheAirTVShows.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchOnTheAirTVShows();
      // assert
      expect(provider.onTheAirTVState, RequestState.error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('popular TV shows', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockGetPopularTVShows.execute())
          .thenAnswer((_) async => Right(tTVList));
      // act
      provider.fetchPopularTVShows();
      // assert
      expect(provider.popularTVState, RequestState.loading);
      // verify(provider.setState(RequestState.Loading));
    });

    test('should change tv shows data when data is gotten successfully',
        () async {
      // arrange
      when(mockGetPopularTVShows.execute())
          .thenAnswer((_) async => Right(tTVList));
      // act
      await provider.fetchPopularTVShows();
      // assert
      expect(provider.popularTVState, RequestState.loaded);
      expect(provider.popularTVShows, tTVList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetPopularTVShows.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchPopularTVShows();
      // assert
      expect(provider.popularTVState, RequestState.error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('top rated TV shows', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockGetTopRatedTVShows.execute())
          .thenAnswer((_) async => Right(tTVList));
      // act
      provider.fetchTopRatedTVShows();
      // assert
      expect(provider.topRatedState, RequestState.loading);
    });

    test('should change tv shows data when data is gotten successfully',
        () async {
      // arrange
      when(mockGetTopRatedTVShows.execute())
          .thenAnswer((_) async => Right(tTVList));
      // act
      await provider.fetchTopRatedTVShows();
      // assert
      expect(provider.topRatedState, RequestState.loaded);
      expect(provider.topRatedTVShows, tTVList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetTopRatedTVShows.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchTopRatedTVShows();
      // assert
      expect(provider.topRatedState, RequestState.error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
