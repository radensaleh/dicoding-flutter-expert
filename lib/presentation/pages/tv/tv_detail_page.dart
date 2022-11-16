import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/entities/tv/tv_detail.dart';
import 'package:ditonton/presentation/pages/tv/tv_season_detail_page.dart';
import 'package:ditonton/presentation/provider/tv/tv_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class TVDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detail-tv';
  final int id;

  const TVDetailPage({required this.id});

  @override
  State<TVDetailPage> createState() => _TVDetailPageState();
}

class _TVDetailPageState extends State<TVDetailPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await Provider.of<TVDetailNotifier>(context, listen: false)
          .fetchTVShowDetail(widget.id);
      await Provider.of<TVDetailNotifier>(context, listen: false)
          .loadWatchlistStatus(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<TVDetailNotifier>(
        builder: (context, provider, child) {
          final state = provider.tvState;

          if (state == RequestState.loading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state == RequestState.loaded) {
            return SafeArea(
              child: DetailContentTVShow(
                tv: provider.tvDetail,
                recommendations: provider.tvRecommendations,
                isAddedWatchlist: provider.isAddedToWatchlist,
              ),
            );
          } else {
            return Text(provider.message);
          }
        },
      ),
    );
  }
}

class DetailContentTVShow extends StatelessWidget {
  final TVDetail tv;
  final List<TV> recommendations;
  final bool isAddedWatchlist;

  const DetailContentTVShow({
    required this.tv,
    required this.recommendations,
    required this.isAddedWatchlist,
  });

  @override
  Widget build(BuildContext context) {
    final sizeWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${tv.posterPath}',
          width: sizeWidth,
          placeholder: (context, url) =>
              Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            minChildSize: 0.25,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: kRichBlack,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(16.0)),
                ),
                padding: const EdgeInsets.only(
                  top: 16,
                  left: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tv.name,
                              style: kHeading5,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (!isAddedWatchlist) {
                                  await Provider.of<TVDetailNotifier>(context,
                                          listen: false)
                                      .addWatchlist(tv);
                                } else {
                                  await Provider.of<TVDetailNotifier>(context,
                                          listen: false)
                                      .removeFromWatchlist(tv);
                                }

                                final message = Provider.of<TVDetailNotifier>(
                                        context,
                                        listen: false)
                                    .watchlistMessage;

                                if (message ==
                                        TVDetailNotifier
                                            .watchlistAddSuccessMessage ||
                                    message ==
                                        TVDetailNotifier
                                            .watchlistRemoveSuccessMessage) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(message)));
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) =>
                                        AlertDialog(content: Text(message)),
                                  );
                                }
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  isAddedWatchlist
                                      ? Icon(Icons.check)
                                      : Icon(Icons.add),
                                  Text(' Watchlist'),
                                ],
                              ),
                            ),
                            Text(_showGenres(tv.genres)),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                  itemCount: 5,
                                  rating: tv.voteAverage / 2,
                                ),
                                Text('${tv.voteAverage}'),
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              tv.overview == '' ? '-' : tv.overview,
                            ),
                            SizedBox(height: 16),
                            Text(
                              '${tv.seasons.length} Seasons',
                              style: kHeading6,
                            ),
                            SizedBox(height: 8),
                            tv.seasons.length == 0
                                ? Text('-')
                                : Container(
                                    height: 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: tv.seasons.length,
                                      itemBuilder: (context, index) {
                                        final tvs = tv.seasons[index];

                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: () =>
                                                Navigator.pushReplacementNamed(
                                              context,
                                              TVSeasonDetailPage.ROUTE_NAME,
                                              arguments: {
                                                'tvId': tv.id,
                                                'seasonNumber':
                                                    tvs.seasonNumber,
                                              },
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8.0),
                                              ),
                                              child: tvs.posterPath == null
                                                  ? Image.asset(
                                                      'assets/circle-g.png',
                                                      width: 100,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : CachedNetworkImage(
                                                      imageUrl:
                                                          'https://image.tmdb.org/t/p/w500${tvs.posterPath}',
                                                      placeholder:
                                                          (context, url) =>
                                                              Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Icon(Icons.error),
                                                    ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                            SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            SizedBox(height: 8),
                            recommendations.length == 0
                                ? Text('-')
                                : Consumer<TVDetailNotifier>(
                                    builder: (context, data, child) {
                                      final state = data.recommendationState;
                                      if (state == RequestState.loading) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else if (state == RequestState.error) {
                                        return Text(data.message);
                                      } else if (state == RequestState.loaded) {
                                        return Container(
                                          height: 150,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: recommendations.length,
                                            itemBuilder: (context, index) {
                                              final tv = recommendations[index];
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: InkWell(
                                                  onTap: () => Navigator
                                                      .pushReplacementNamed(
                                                    context,
                                                    TVDetailPage.ROUTE_NAME,
                                                    arguments: tv.id,
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(8.0),
                                                    ),
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          'https://image.tmdb.org/t/p/w500${tv.posterPath}',
                                                      placeholder:
                                                          (context, url) =>
                                                              Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Icon(Icons.error),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      } else {
                                        return Container();
                                      }
                                    },
                                  ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += genre.name + ', ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }
}
