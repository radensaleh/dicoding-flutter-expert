import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv/season_detail.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/entities/tv/tv_detail.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_season_detail.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_show_detail.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_show_recommendations.dart';
import 'package:ditonton/domain/usecases/tv/get_watchlist_tv_status.dart';
import 'package:ditonton/domain/usecases/tv/remove_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/tv/save_watchlist_tv.dart';
import 'package:flutter/widgets.dart';

class TVSeasonDetailNotifier extends ChangeNotifier {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTVShowDetail getTVShowDetail;
  final GetTVSeasonDetail getTVSeasonDetail;
  final GetTVShowRecommendations getTVShowRecommendations;
  final GetWatchlistTVStatus getWatchlistTVStatus;
  final SaveWatchlistTV saveWatchlistTV;
  final RemoveWatchlistTV removeWatchlistTV;

  TVSeasonDetailNotifier({
    required this.getTVShowDetail,
    required this.getTVSeasonDetail,
    required this.getTVShowRecommendations,
    required this.getWatchlistTVStatus,
    required this.removeWatchlistTV,
    required this.saveWatchlistTV,
  });

  late TVDetail _tvDetail;
  TVDetail get tvDetail => _tvDetail;

  RequestState _tvDetailState = RequestState.empty;
  RequestState get tvDetailState => _tvDetailState;

  late SeasonDetail _seasonDetail;
  SeasonDetail get seasonDetail => _seasonDetail;

  RequestState _seasonState = RequestState.empty;
  RequestState get seasonState => _seasonState;

  List<TV> _tvRecommendations = [];
  List<TV> get tvRecommendations => _tvRecommendations;

  RequestState _recommendationState = RequestState.empty;
  RequestState get recommendationState => _recommendationState;

  String _message = '';
  String get message => _message;

  Future<void> fetchSeasonDetail(int tvId, int seasonNumber) async {
    _seasonState = RequestState.loading;
    notifyListeners();

    final detailResult = await getTVSeasonDetail.execute(tvId, seasonNumber);
    final recommendationResult = await getTVShowRecommendations.execute(tvId);
    final tvDetailResult = await getTVShowDetail.execute(tvId);

    detailResult.fold(
      (failure) {
        _seasonState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (seasonDetail) {
        _recommendationState = RequestState.loading;
        _seasonDetail = seasonDetail;
        notifyListeners();
        recommendationResult.fold(
          (failure) {
            _recommendationState = RequestState.error;
            _message = failure.message;
            notifyListeners();
          },
          (tvDetail) {
            _tvDetailState = RequestState.loading;
            _tvRecommendations = tvDetail;
            notifyListeners();
            tvDetailResult.fold(
              (failure) {
                _tvDetailState = RequestState.error;
                _message = failure.message;
                notifyListeners();
              },
              (tvDetail) {
                _tvDetailState = RequestState.loaded;
                _tvDetail = tvDetail;
                notifyListeners();
              },
            );
            _recommendationState = RequestState.loaded;
            notifyListeners();
          },
        );
        _seasonState = RequestState.loaded;
        notifyListeners();
      },
    );
  }

  String _watchlistMessage = '';
  String get watchlistMessage => _watchlistMessage;

  bool _isAddedToWatchlist = false;
  bool get isAddedToWatchlist => _isAddedToWatchlist;

  Future<void> loadWatchlistStatus(int id) async {
    final result = await getWatchlistTVStatus.execute(id);
    _isAddedToWatchlist = result;
    notifyListeners();
  }

  Future<void> addWatchlist(TVDetail tv) async {
    final result = await saveWatchlistTV.execute(tv);

    await result.fold(
      (failure) async => _watchlistMessage = failure.message,
      (successMessage) async => _watchlistMessage = successMessage,
    );

    await loadWatchlistStatus(tv.id);
  }

  Future<void> removeFromWatchlist(TVDetail tv) async {
    final result = await removeWatchlistTV.execute(tv);

    await result.fold(
      (failure) async => _watchlistMessage = failure.message,
      (successMessage) async => _watchlistMessage = successMessage,
    );

    await loadWatchlistStatus(tv.id);
  }
}
