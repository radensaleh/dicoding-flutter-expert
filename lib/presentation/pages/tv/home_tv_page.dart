import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/home_movie_page.dart';
import 'package:ditonton/presentation/pages/tv/on_the_air_tv_page.dart';
import 'package:ditonton/presentation/pages/tv/popular_tv_page.dart';
import 'package:ditonton/presentation/pages/tv/search_tv_page.dart';
import 'package:ditonton/presentation/pages/tv/top_rated_tv_page.dart';
import 'package:ditonton/presentation/pages/tv/tv_detail_page.dart';
import 'package:ditonton/presentation/pages/tv/watchlist_tv_page.dart';
import 'package:ditonton/presentation/pages/watchlist_movies_page.dart';
import 'package:ditonton/presentation/provider/tv/tv_list_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeTVPage extends StatefulWidget {
  static const ROUTE_NAME = '/tv-show';
  const HomeTVPage({Key? key}) : super(key: key);

  @override
  State<HomeTVPage> createState() => _HomeTVPageState();
}

class _HomeTVPageState extends State<HomeTVPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<TVListNotifier>(context, listen: false)
        ..fetchOnTheAirTVShows()
        ..fetchPopularTVShows()
        ..fetchTopRatedTVShows(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('Ditonton'),
              accountEmail: Text('ditonton@dicoding.com'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/circle-g.png'),
              ),
            ),
            ListTile(
              leading: Icon(Icons.movie),
              title: Text('Movies'),
              onTap: () =>
                  Navigator.pushNamed(context, HomeMoviePage.ROUTE_NAME),
            ),
            ListTile(
              leading: Icon(Icons.save_alt),
              title: Text('Watchlist'),
              onTap: () =>
                  Navigator.pushNamed(context, WatchlistMoviesPage.ROUTE_NAME),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.tv),
              title: Text('TV Shows'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.save_alt),
              title: Text('Watchlist TV Shows'),
              onTap: () =>
                  Navigator.pushNamed(context, WatchlistTVPage.ROUTE_NAME),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('About'),
              onTap: () => Navigator.pushNamed(context, AboutPage.ROUTE_NAME),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Ditonton'),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, SearchTVPage.ROUTE_NAME),
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSubHeading(
                title: 'TV Shows',
                onTap: () =>
                    Navigator.pushNamed(context, OnTheAirTVPage.ROUTE_NAME),
              ),
              Consumer<TVListNotifier>(
                builder: (context, data, child) {
                  final state = data.onTheAirTVState;
                  if (state == RequestState.loading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state == RequestState.loaded) {
                    return TVList(data.onTheAirTVShows);
                  } else {
                    return Text(data.message);
                  }
                },
              ),
              _buildSubHeading(
                title: 'Popular TV Shows',
                onTap: () =>
                    Navigator.pushNamed(context, PopularTVPage.ROUTE_NAME),
              ),
              Consumer<TVListNotifier>(
                builder: (context, data, child) {
                  final state = data.popularTVState;
                  if (state == RequestState.loading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state == RequestState.loaded) {
                    return TVList(data.popularTVShows);
                  } else {
                    return Text(data.message);
                  }
                },
              ),
              _buildSubHeading(
                title: 'Top Rated TV Shows',
                onTap: () =>
                    Navigator.pushNamed(context, TopRatedTVPage.ROUTE_NAME),
              ),
              Consumer<TVListNotifier>(
                builder: (context, data, child) {
                  final state = data.topRatedState;
                  if (state == RequestState.loading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state == RequestState.loaded) {
                    return TVList(data.topRatedTVShows);
                  } else {
                    return Text(data.message);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text('See More'),
                Icon(Icons.arrow_forward_ios),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TVList extends StatelessWidget {
  final List<TV> tvs;

  TVList(this.tvs);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tvs.length,
        itemBuilder: (context, index) {
          final tv = tvs[index];
          return Container(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () => Navigator.pushNamed(
                context,
                TVDetailPage.ROUTE_NAME,
                arguments: tv.id,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(16.0),
                ),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${tv.posterPath}',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
