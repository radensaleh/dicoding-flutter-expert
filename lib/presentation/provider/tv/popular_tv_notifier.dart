import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_popular_tv_shows.dart';
import 'package:flutter/cupertino.dart';

class PopularTVNotifier extends ChangeNotifier {
  final GetPopularTVShows getPopularTVShows;

  PopularTVNotifier({required this.getPopularTVShows});

  RequestState _state = RequestState.empty;
  RequestState get state => _state;

  List<TV> _tvShows = [];
  List<TV> get tvShows => _tvShows;

  String _message = '';
  String get message => _message;

  Future<void> fetchPopularTVShows() async {
    _state = RequestState.loading;
    notifyListeners();

    final result = await getPopularTVShows.execute();
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
