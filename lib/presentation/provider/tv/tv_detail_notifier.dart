import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/entities/tv/tv_detail.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_show_detail.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_show_recommendations.dart';
import 'package:ditonton/domain/usecases/tv/get_watchlist_tv_status.dart';
import 'package:ditonton/domain/usecases/tv/remove_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/tv/save_watchlist_tv.dart';
import 'package:flutter/widgets.dart';

class TVDetailNotifier extends ChangeNotifier {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTVShowDetail getTVShowDetail;
  final GetTVShowRecommendations getTVShowRecommendations;
  final GetWatchlistTVStatus getWatchlistTVStatus;
  final SaveWatchlistTV saveWatchlistTV;
  final RemoveWatchlistTV removeWatchlistTV;

  TVDetailNotifier({
    required this.getTVShowDetail,
    required this.getTVShowRecommendations,
    required this.getWatchlistTVStatus,
    required this.saveWatchlistTV,
    required this.removeWatchlistTV,
  });

  late TVDetail _tvDetail;
  TVDetail get tvDetail => _tvDetail;

  RequestState _tvState = RequestState.empty;
  RequestState get tvState => _tvState;

  List<TV> _tvRecommendations = [];
  List<TV> get tvRecommendations => _tvRecommendations;

  RequestState _recommendationState = RequestState.empty;
  RequestState get recommendationState => _recommendationState;

  String _message = '';
  String get message => _message;

  bool _isAddedToWatchlist = false;
  bool get isAddedToWatchlist => _isAddedToWatchlist;

  Future<void> fetchTVShowDetail(int id) async {
    _tvState = RequestState.loading;
    notifyListeners();

    final detailResult = await getTVShowDetail.execute(id);
    final recommendationResult = await getTVShowRecommendations.execute(id);

    detailResult.fold(
      (failure) {
        _tvState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (tvDetail) {
        _recommendationState = RequestState.loading;
        _tvDetail = tvDetail;
        notifyListeners();
        recommendationResult.fold(
          (failure) {
            _recommendationState = RequestState.error;
            _message = failure.message;
          },
          (tvDetail) {
            _recommendationState = RequestState.loaded;
            _tvRecommendations = tvDetail;
          },
        );
        _tvState = RequestState.loaded;
        notifyListeners();
      },
    );
  }

  String _watchlistMessage = '';
  String get watchlistMessage => _watchlistMessage;

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
