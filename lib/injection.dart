import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:ditonton/common/network_info.dart';
import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/datasources/movie_local_data_source.dart';
import 'package:ditonton/data/datasources/movie_remote_data_source.dart';
import 'package:ditonton/data/datasources/tv_local_data_source.dart';
import 'package:ditonton/data/datasources/tv_remote_data_source.dart';
import 'package:ditonton/data/repositories/movie_repository_impl.dart';
import 'package:ditonton/data/repositories/tv_repository_impl.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';
import 'package:ditonton/domain/usecases/check_connection.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/domain/usecases/tv/get_on_the_air_tv_shows.dart';
import 'package:ditonton/domain/usecases/tv/get_popular_tv_shows.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_season_detail.dart';
import 'package:ditonton/domain/usecases/tv/get_top_rated_tv_shows.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_show_detail.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_show_recommendations.dart';
import 'package:ditonton/domain/usecases/tv/get_watchlist_tv_shows.dart';
import 'package:ditonton/domain/usecases/tv/get_watchlist_tv_status.dart';
import 'package:ditonton/domain/usecases/tv/remove_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/tv/save_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/tv/search_tv_shows.dart';
import 'package:ditonton/presentation/provider/movie_detail_notifier.dart';
import 'package:ditonton/presentation/provider/movie_list_notifier.dart';
import 'package:ditonton/presentation/provider/movie_search_notifier.dart';
import 'package:ditonton/presentation/provider/popular_movies_notifier.dart';
import 'package:ditonton/presentation/provider/top_rated_movies_notifier.dart';
import 'package:ditonton/presentation/provider/tv/popular_tv_notifier.dart';
import 'package:ditonton/presentation/provider/tv/top_rated_tv_notifier.dart';
import 'package:ditonton/presentation/provider/tv/tv_detail_notifier.dart';
import 'package:ditonton/presentation/provider/tv/tv_list_notifier.dart';
import 'package:ditonton/presentation/provider/tv/tv_search_notifier.dart';
import 'package:ditonton/presentation/provider/tv/tv_season_detail_notifier.dart';
import 'package:ditonton/presentation/provider/tv/watchlist_tv_notifier.dart';
import 'package:ditonton/presentation/provider/watchlist_movie_notifier.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void init() {
  // provider
  locator.registerFactory(
    () => MovieListNotifier(
      getNowPlayingMovies: locator(),
      getPopularMovies: locator(),
      getTopRatedMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieDetailNotifier(
      getMovieDetail: locator(),
      getMovieRecommendations: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieSearchNotifier(
      searchMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => PopularMoviesNotifier(
      locator(),
    ),
  );
  locator.registerFactory(
    () => TopRatedMoviesNotifier(
      getTopRatedMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => WatchlistMovieNotifier(
      getWatchlistMovies: locator(),
    ),
  );

  // use case
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));
  locator.registerLazySingleton(() => CheckConnection(locator()));

  // repository
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
      networkInfo: locator(),
    ),
  );

  // data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl(databaseHelper: locator()));

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // network info
  locator.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(locator()));

  // external
  locator.registerLazySingleton(() => http.Client());
  locator.registerLazySingleton(() => DataConnectionChecker());

  // TV Shows
  // provider
  locator.registerFactory(
    () => TVListNotifier(
      getOnTheAirTVShows: locator(),
      getPopularTVShows: locator(),
      getTopRatedTVShows: locator(),
    ),
  );
  locator.registerFactory(
    () => PopularTVNotifier(
      getPopularTVShows: locator(),
    ),
  );
  locator.registerFactory(
    () => TopRatedTVNotifier(
      getTopRatedTVShows: locator(),
    ),
  );
  locator.registerFactory(
    () => TVDetailNotifier(
      getTVShowDetail: locator(),
      getTVShowRecommendations: locator(),
      getWatchlistTVStatus: locator(),
      saveWatchlistTV: locator(),
      removeWatchlistTV: locator(),
    ),
  );
  locator.registerFactory(
    () => TVSearchNotifier(
      searchTVShows: locator(),
    ),
  );
  locator.registerFactory(
    () => WatchlistTVNotifier(
      getWatchlistTVShows: locator(),
    ),
  );
  locator.registerFactory(
    () => TVSeasonDetailNotifier(
      getTVShowDetail: locator(),
      getTVSeasonDetail: locator(),
      getTVShowRecommendations: locator(),
      getWatchlistTVStatus: locator(),
      removeWatchlistTV: locator(),
      saveWatchlistTV: locator(),
    ),
  );

  // use case
  locator.registerLazySingleton(
    () => GetOnTheAirTVShows(repository: locator()),
  );
  locator.registerLazySingleton(
    () => GetPopularTVShows(repository: locator()),
  );
  locator.registerLazySingleton(
    () => GetTopRatedTVShows(repository: locator()),
  );
  locator.registerLazySingleton(
    () => GetTVShowDetail(repository: locator()),
  );
  locator.registerLazySingleton(
    () => GetTVShowRecommendations(repository: locator()),
  );
  locator.registerLazySingleton(
    () => SearchTVShows(repository: locator()),
  );
  locator.registerLazySingleton(
    () => SaveWatchlistTV(repository: locator()),
  );
  locator.registerLazySingleton(
    () => RemoveWatchlistTV(repository: locator()),
  );
  locator.registerLazySingleton(
    () => GetWatchlistTVShows(repository: locator()),
  );
  locator.registerLazySingleton(
    () => GetWatchlistTVStatus(repository: locator()),
  );
  locator.registerLazySingleton(
    () => GetTVSeasonDetail(repository: locator()),
  );

  // repository
  locator.registerLazySingleton<TVRepository>(
    () => TVRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // data source
  locator.registerLazySingleton<TVLocalDataSource>(
    () => TVLocalDataSourceImpl(databaseHelper: locator()),
  );

  locator.registerLazySingleton<TVRemoteDataSource>(
    () => TVRemoteDataSourceImpl(client: locator()),
  );
}
