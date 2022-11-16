import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_popular_tv_shows.dart';
import 'package:ditonton/presentation/provider/tv/popular_tv_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'popular_tv_notifier_test.mocks.dart';

@GenerateMocks([GetPopularTVShows])
void main() {
  late MockGetPopularTVShows mockGetPopularTVShows;
  late PopularTVNotifier notifier;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetPopularTVShows = MockGetPopularTVShows();
    notifier = PopularTVNotifier(getPopularTVShows: mockGetPopularTVShows)
      ..addListener(() {
        listenerCallCount++;
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

  test('should change state to loading when usecase is called', () async {
    // arrange
    when(mockGetPopularTVShows.execute())
        .thenAnswer((_) async => Right(tTVList));
    // act
    notifier.fetchPopularTVShows();
    // assert
    expect(notifier.state, RequestState.loading);
    expect(listenerCallCount, 1);
  });

  test('should change tv shows data when data is gotten successfully',
      () async {
    // arrange
    when(mockGetPopularTVShows.execute())
        .thenAnswer((_) async => Right(tTVList));
    // act
    await notifier.fetchPopularTVShows();
    // assert
    expect(notifier.state, RequestState.loaded);
    expect(notifier.tvShows, tTVList);
    expect(listenerCallCount, 2);
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockGetPopularTVShows.execute())
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
    // act
    await notifier.fetchPopularTVShows();
    // assert
    expect(notifier.state, RequestState.error);
    expect(notifier.message, 'Server Failure');
    expect(listenerCallCount, 2);
  });
}
