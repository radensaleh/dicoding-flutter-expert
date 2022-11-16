import 'package:ditonton/data/models/tv/tv_model.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tTVModel = TVModel(
    backdropPath: 'backdropPath',
    firstAirDate: null,
    genreIds: [1, 2, 3],
    id: 1,
    name: 'Chucky',
    originCountry: ['en', 'fr'],
    originalLanguage: 'en',
    originalName: 'originalName',
    overview: 'this is overview',
    popularity: 5.2,
    posterPath: '/12dwi019adjwid1.png',
    voteAverage: 75.2,
    voteCount: 1,
  );

  final tTV = TV(
    backdropPath: 'backdropPath',
    firstAirDate: null,
    genreIds: [1, 2, 3],
    id: 1,
    name: 'Chucky',
    originCountry: ['en', 'fr'],
    originalLanguage: 'en',
    originalName: 'originalName',
    overview: 'this is overview',
    popularity: 5.2,
    posterPath: '/12dwi019adjwid1.png',
    voteAverage: 75.2,
    voteCount: 1,
  );

  test('should be a subclass of TV entity', () async {
    final result = tTVModel.toEntity();
    expect(result, tTV);
  });
}
