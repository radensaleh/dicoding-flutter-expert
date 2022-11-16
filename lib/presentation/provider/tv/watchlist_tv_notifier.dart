import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_watchlist_tv_shows.dart';
import 'package:flutter/widgets.dart';

class WatchlistTVNotifier extends ChangeNotifier {
  var _watchlistTVShows = <TV>[];
  List<TV> get watchlistTVShows => _watchlistTVShows;

  var _watchlistState = RequestState.empty;
  RequestState get watchlistState => _watchlistState;

  String _message = '';
  String get message => _message;

  final GetWatchlistTVShows getWatchlistTVShows;

  WatchlistTVNotifier({required this.getWatchlistTVShows});

  Future<void> fetchWatchlistTVShows() async {
    _watchlistState = RequestState.loading;
    notifyListeners();

    final result = await getWatchlistTVShows.execute();
    result.fold(
      (failure) {
        _watchlistState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (tvData) {
        _watchlistState = RequestState.loaded;
        _watchlistTVShows = tvData;
        notifyListeners();
      },
    );
  }
}
