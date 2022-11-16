import 'package:ditonton/data/models/movie_table.dart';
import 'package:ditonton/data/models/tv/tv_table.dart';
import 'package:ditonton/data/models/tv_season/episode_model.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/entities/tv/season.dart';
import 'package:ditonton/domain/entities/tv/season_detail.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/entities/tv/tv_detail.dart';

final testMovie = Movie(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: [14, 28],
  id: 557,
  originalTitle: 'Spider-Man',
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  releaseDate: '2002-05-01',
  title: 'Spider-Man',
  video: false,
  voteAverage: 7.2,
  voteCount: 13507,
);

final testMovieList = [testMovie];

final testMovieDetail = MovieDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalTitle: 'originalTitle',
  overview: 'overview',
  posterPath: 'posterPath',
  releaseDate: 'releaseDate',
  runtime: 120,
  title: 'title',
  voteAverage: 1,
  voteCount: 1,
);

final testMovieCache = MovieTable(
  id: 557,
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  title: 'Spider-Man',
);

final testMovieCacheMap = {
  'id': 557,
  'overview':
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  'posterPath': '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  'title': 'Spider-Man',
};

final testMovieFromCache = Movie.watchlist(
  id: 557,
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  title: 'Spider-Man',
);

final testWatchlistMovie = Movie.watchlist(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieTable = MovieTable(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'title',
};

// TV Shows Dummy Data
final testTVTable = TVTable(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testTVMap = {
  'id': 1,
  'name': 'name',
  'posterPath': 'posterPath',
  'overview': 'overview',
};

final testTVSeasonDetail = SeasonDetail(
  id: '1',
  airDate: '2019-04-22',
  episodes: [
    EpisodeModel(
      airDate: '2019-04-22',
      episodeNumber: 1,
      id: 1,
      name: 'name',
      overview: 'overview',
      productionCode: 'productionCode',
      runtime: 21,
      seasonNumber: 1,
      showId: 2,
      stillPath: 'stillPath',
      voteAverage: 2.2,
      voteCount: 1,
      crew: [],
      guestStars: [],
    )
  ],
  name: 'name',
  overview: 'overview',
  seasonDetailResponseId: 1,
  posterPath: 'posterPath',
  seasonNumber: 11,
);

final testTVDetail = TVDetail(
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'name')],
  homepage: 'homepage',
  id: 1,
  inProduction: false,
  languages: ['us'],
  lastAirDate: null,
  name: 'name',
  numberOfEpisodes: 1,
  numberOfSeasons: 2,
  seasons: [
    Season(
      airDate: null,
      episodeCount: 1,
      id: 2,
      name: 'name',
      overview: 'overview',
      posterPath: 'posterPath',
      seasonNumber: 2,
    )
  ],
  originCountry: ['originCountry'],
  originalLanguage: 'originalLanguage',
  originalName: 'originalName',
  overview: 'overview',
  popularity: 2.2,
  posterPath: 'posterPath',
  productionCompanies: ['productionCompanies'],
  status: 'status',
  tagline: 'tagline',
  type: 'type',
  voteAverage: 2.1,
  voteCount: 22,
);

final testWatchlistTVShow = TV.watchlist(
  id: 1,
  overview: 'overview',
  posterPath: 'posterPath',
  name: 'name',
);

final testSeasonDetail = SeasonDetail(
  id: "1",
  airDate: "airDate",
  episodes: [
    EpisodeModel(
      airDate: "airDate",
      episodeNumber: 2,
      id: 1,
      name: 'name',
      overview: 'overview',
      productionCode: '1',
      runtime: 3,
      seasonNumber: 1,
      showId: 2,
      stillPath: 'stillPath',
      voteAverage: 2.1,
      voteCount: 22,
      crew: [],
      guestStars: [],
    ),
  ],
  name: 'name',
  overview: 'overview',
  seasonDetailResponseId: 2,
  posterPath: 'posterPath',
  seasonNumber: 2,
);
