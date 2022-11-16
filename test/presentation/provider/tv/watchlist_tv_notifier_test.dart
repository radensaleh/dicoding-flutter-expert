import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/tv/get_watchlist_tv_shows.dart';
import 'package:ditonton/presentation/provider/tv/watchlist_tv_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'watchlist_tv_notifier_test.mocks.dart';

@GenerateMocks([GetWatchlistTVShows])
void main() {
  late WatchlistTVNotifier provider;
  late MockGetWatchlistTVShows mockGetWatchlistTVShows;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetWatchlistTVShows = MockGetWatchlistTVShows();
    provider = WatchlistTVNotifier(getWatchlistTVShows: mockGetWatchlistTVShows)
      ..addListener(() {
        listenerCallCount += 1;
      });
  });

  test('should change tv show data when data is gotten successfully', () async {
    // arrange
    when(mockGetWatchlistTVShows.execute())
        .thenAnswer((_) async => Right([testWatchlistTVShow]));
    // act
    await provider.fetchWatchlistTVShows();
    // assert
    expect(provider.watchlistState, RequestState.loaded);
    expect(provider.watchlistTVShows, [testWatchlistTVShow]);
    expect(listenerCallCount, 2);
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockGetWatchlistTVShows.execute())
        .thenAnswer((_) async => Left(DatabaseFailure("Can't get data")));
    // act
    await provider.fetchWatchlistTVShows();
    // assert
    expect(provider.watchlistState, RequestState.error);
    expect(provider.message, "Can't get data");
    expect(listenerCallCount, 2);
  });
}
