import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_top_rated_tv_shows.dart';
import 'package:flutter/widgets.dart';

class TopRatedTVNotifier extends ChangeNotifier {
  final GetTopRatedTVShows getTopRatedTVShows;

  TopRatedTVNotifier({required this.getTopRatedTVShows});

  RequestState _state = RequestState.empty;
  RequestState get state => _state;

  List<TV> _tvShows = [];
  List<TV> get tvShows => _tvShows;

  String _message = '';
  String get message => _message;

  Future<void> fetchTopRatedTVShows() async {
    _state = RequestState.loading;
    notifyListeners();

    final result = await getTopRatedTVShows.execute();
    result.fold(
      (failure) {
        _state = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (tvData) {
        _state = RequestState.loaded;
        _tvShows = tvData;
        notifyListeners();
      },
    );
  }
}
