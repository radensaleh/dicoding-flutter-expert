import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_on_the_air_tv_shows.dart';
import 'package:ditonton/domain/usecases/tv/get_popular_tv_shows.dart';
import 'package:ditonton/domain/usecases/tv/get_top_rated_tv_shows.dart';
import 'package:flutter/widgets.dart';

class TVListNotifier extends ChangeNotifier {
  var _onTheAirTVShows = <TV>[];
  List<TV> get onTheAirTVShows => _onTheAirTVShows;

  RequestState _onTheAirTVState = RequestState.empty;
  RequestState get onTheAirTVState => _onTheAirTVState;

  var _popularTVShows = <TV>[];
  List<TV> get popularTVShows => _popularTVShows;

  RequestState _popularTVState = RequestState.empty;
  RequestState get popularTVState => _popularTVState;

  var _topRatedTVShows = <TV>[];
  List<TV> get topRatedTVShows => _topRatedTVShows;

  RequestState _topRatedTVState = RequestState.empty;
  RequestState get topRatedState => _topRatedTVState;

  String _message = '';
  String get message => _message;

  final GetOnTheAirTVShows getOnTheAirTVShows;
  final GetPopularTVShows getPopularTVShows;
  final GetTopRatedTVShows getTopRatedTVShows;

  TVListNotifier({
    required this.getOnTheAirTVShows,
    required this.getPopularTVShows,
    required this.getTopRatedTVShows,
  });

  Future<void> fetchOnTheAirTVShows() async {
    _onTheAirTVState = RequestState.loading;
    notifyListeners();

    final result = await getOnTheAirTVShows.execute();
    result.fold(
      (failure) {
        _onTheAirTVState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (tvData) {
        _onTheAirTVState = RequestState.loaded;
        _onTheAirTVShows = tvData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchPopularTVShows() async {
    _popularTVState = RequestState.loading;
    notifyListeners();

    final result = await getPopularTVShows.execute();
    result.fold(
      (failure) {
        _popularTVState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (tvData) {
        _popularTVState = RequestState.loaded;
        _popularTVShows = tvData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchTopRatedTVShows() async {
    _topRatedTVState = RequestState.loading;
    notifyListeners();

    final result = await getTopRatedTVShows.execute();
    result.fold(
      (failure) {
        _topRatedTVState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (tvData) {
        _topRatedTVState = RequestState.loaded;
        _topRatedTVShows = tvData;
        notifyListeners();
      },
    );
  }
}
