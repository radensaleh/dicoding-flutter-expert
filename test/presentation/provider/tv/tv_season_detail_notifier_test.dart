import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_season_detail.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_show_detail.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_show_recommendations.dart';
import 'package:ditonton/domain/usecases/tv/get_watchlist_tv_status.dart';
import 'package:ditonton/domain/usecases/tv/remove_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/tv/save_watchlist_tv.dart';
import 'package:ditonton/presentation/provider/tv/tv_season_detail_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'tv_season_detail_notifier_test.mocks.dart';

@GenerateMocks([
  GetTVShowDetail,
  GetTVSeasonDetail,
  GetTVShowRecommendations,
  GetWatchlistTVStatus,
  SaveWatchlistTV,
  RemoveWatchlistTV,
])
void main() {
  late TVSeasonDetailNotifier provider;
  late MockGetTVShowDetail mockGetTVShowDetail;
  late MockGetTVSeasonDetail mockGetTVSeasonDetail;
  late MockGetTVShowRecommendations mockGetTVShowRecommendations;
  late MockGetWatchlistTVStatus mockGetWatchlistTVStatus;
  late MockSaveWatchlistTV mockSaveWatchlistTV;
  late MockRemoveWatchlistTV mockRemoveWatchlistTV;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetTVShowDetail = MockGetTVShowDetail();
    mockGetTVSeasonDetail = MockGetTVSeasonDetail();
    mockGetTVShowRecommendations = MockGetTVShowRecommendations();
    mockGetWatchlistTVStatus = MockGetWatchlistTVStatus();
    mockSaveWatchlistTV = MockSaveWatchlistTV();
    mockRemoveWatchlistTV = MockRemoveWatchlistTV();
    provider = TVSeasonDetailNotifier(
      getTVShowDetail: mockGetTVShowDetail,
      getTVSeasonDetail: mockGetTVSeasonDetail,
      getTVShowRecommendations: mockGetTVShowRecommendations,
      getWatchlistTVStatus: mockGetWatchlistTVStatus,
      removeWatchlistTV: mockRemoveWatchlistTV,
      saveWatchlistTV: mockSaveWatchlistTV,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  final tId = 1;
  final tSeasonNumber = 2;

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

  void _arrangeUsecase() {
    when(mockGetTVSeasonDetail.execute(tId, tSeasonNumber))
        .thenAnswer((_) async => Right(testSeasonDetail));
    when(mockGetTVShowDetail.execute(tId))
        .thenAnswer((_) async => Right(testTVDetail));
    when(mockGetTVShowRecommendations.execute(tId))
        .thenAnswer((_) async => Right(tTVList));
  }

  group('Get TV Season Detail', () {
    test('should get data from the usecase', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchSeasonDetail(tId, tSeasonNumber);
      // assert
      verify(mockGetTVSeasonDetail.execute(tId, tSeasonNumber));
      expect(provider.seasonDetail, testSeasonDetail);
    });

    test('should update season detail state when data is gotten successfully',
        () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchSeasonDetail(tId, tSeasonNumber);
      // assert
      expect(provider.seasonState, RequestState.loaded);
      expect(provider.seasonDetail, testSeasonDetail);
    });

    test('should update error message when request in successful', () async {
      // arrange
      when(mockGetTVSeasonDetail.execute(tId, tSeasonNumber))
          .thenAnswer((_) async => Left(ServerFailure('Failed')));

      when(mockGetTVShowRecommendations.execute(tId))
          .thenAnswer((_) async => Right(tTVList));

      when(mockGetTVShowDetail.execute(tId))
          .thenAnswer((_) async => Right(testTVDetail));
      // act
      await provider.fetchSeasonDetail(tId, tSeasonNumber);
      // assert
      expect(provider.seasonState, RequestState.error);
      expect(provider.message, 'Failed');
    });
  });

  group('Get TV shows Detail', () {
    test('should get data from the usecase', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchSeasonDetail(tId, tSeasonNumber);
      // assert
      verify(mockGetTVShowDetail.execute(tId));
      verify(mockGetTVShowRecommendations.execute(tId));
    });

    test('should change state to Loading when usecase is called', () {
      // arrange
      _arrangeUsecase();
      // act
      provider.fetchSeasonDetail(tId, tSeasonNumber);
      // assert
      expect(provider.seasonState, RequestState.loading);
      expect(listenerCallCount, 1);
    });

    test('should change TV shows when data is gotten successfully', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchSeasonDetail(tId, tSeasonNumber);
      // assert
      expect(provider.seasonState, RequestState.loaded);
      expect(provider.tvDetail, testTVDetail);
      expect(listenerCallCount, 6);
    });

    test(
        'should change recommendation TV shows when data is gotten successfully',
        () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchSeasonDetail(tId, tSeasonNumber);
      // assert
      expect(provider.seasonState, RequestState.loaded);
      expect(provider.tvRecommendations, tTVList);
    });
  });

  group('Get TV shows Recommendations', () {
    test('should get data from the usecase', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchSeasonDetail(tId, tSeasonNumber);
      // assert
      verify(mockGetTVShowRecommendations.execute(tId));
      expect(provider.tvRecommendations, tTVList);
    });

    test('should update recommendation state when data is gotten successfully',
        () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchSeasonDetail(tId, tSeasonNumber);
      // assert
      expect(provider.recommendationState, RequestState.loaded);
      expect(provider.tvRecommendations, tTVList);
    });

    test('should update error message when request in successful', () async {
      // arrange
      when(mockGetTVSeasonDetail.execute(tId, tSeasonNumber))
          .thenAnswer((_) async => Right(testSeasonDetail));

      when(mockGetTVShowRecommendations.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Failed')));

      when(mockGetTVShowDetail.execute(tId))
          .thenAnswer((_) async => Right(testTVDetail));
      // act
      await provider.fetchSeasonDetail(tId, tSeasonNumber);
      // assert
      expect(provider.recommendationState, RequestState.error);
      expect(provider.message, 'Failed');
    });
  });

  group('Watchlist', () {
    test('should get the watchlist status', () async {
      // arrange
      when(mockGetWatchlistTVStatus.execute(1)).thenAnswer((_) async => true);
      // act
      await provider.loadWatchlistStatus(1);
      // assert
      expect(provider.isAddedToWatchlist, true);
    });

    test('should execute save watchlist when function called', () async {
      // arrange
      when(mockSaveWatchlistTV.execute(testTVDetail))
          .thenAnswer((_) async => Right('Success'));
      when(mockGetWatchlistTVStatus.execute(testTVDetail.id))
          .thenAnswer((_) async => true);
      // act
      await provider.addWatchlist(testTVDetail);
      // assert
      verify(mockSaveWatchlistTV.execute(testTVDetail));
    });

    test('should execute remove watchlist when function called', () async {
      // arrange
      when(mockRemoveWatchlistTV.execute(testTVDetail))
          .thenAnswer((_) async => Right('Removed'));
      when(mockGetWatchlistTVStatus.execute(testTVDetail.id))
          .thenAnswer((_) async => false);
      // act
      await provider.removeFromWatchlist(testTVDetail);
      // assert
      verify(mockRemoveWatchlistTV.execute(testTVDetail));
    });

    test('should update watchlist status when add watchlist success', () async {
      // arrange
      when(mockSaveWatchlistTV.execute(testTVDetail))
          .thenAnswer((_) async => Right('Added TV to Watchlist'));
      when(mockGetWatchlistTVStatus.execute(testTVDetail.id))
          .thenAnswer((_) async => true);
      // act
      await provider.addWatchlist(testTVDetail);
      // assert
      verify(mockGetWatchlistTVStatus.execute(testTVDetail.id));
      expect(provider.isAddedToWatchlist, true);
      expect(provider.watchlistMessage, 'Added TV to Watchlist');
      expect(listenerCallCount, 1);
    });

    test('should update watchlist message when add watchlist failed', () async {
      // arrange
      when(mockSaveWatchlistTV.execute(testTVDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      when(mockGetWatchlistTVStatus.execute(testTVDetail.id))
          .thenAnswer((_) async => false);
      // act
      await provider.addWatchlist(testTVDetail);
      // assert
      expect(provider.watchlistMessage, 'Failed');
      expect(listenerCallCount, 1);
    });
  });

  group('on Error', () {
    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetTVSeasonDetail.execute(tId, tSeasonNumber))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

      when(mockGetTVShowRecommendations.execute(tId))
          .thenAnswer((_) async => Right(tTVList));

      when(mockGetTVShowDetail.execute(tId))
          .thenAnswer((_) async => Right(testTVDetail));

      // act
      await provider.fetchSeasonDetail(tId, tSeasonNumber);
      // assert
      expect(provider.seasonState, RequestState.error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
