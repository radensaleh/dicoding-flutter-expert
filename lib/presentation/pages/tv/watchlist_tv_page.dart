import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/presentation/provider/tv/watchlist_tv_notifier.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WatchlistTVPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-tv';
  const WatchlistTVPage({Key? key}) : super(key: key);

  @override
  State<WatchlistTVPage> createState() => _WatchlistTVPageState();
}

class _WatchlistTVPageState extends State<WatchlistTVPage> with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<WatchlistTVNotifier>(context, listen: false)
            .fetchWatchlistTVShows());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  void didPopNext() {
    Provider.of<WatchlistTVNotifier>(context, listen: false)
        .fetchWatchlistTVShows();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist TV Shows'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<WatchlistTVNotifier>(
          builder: (context, data, child) {
            final state = data.watchlistState;
            if (state == RequestState.loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state == RequestState.loaded) {
              final result = data.watchlistTVShows;
              if (result.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/search_not_found.png'),
                      SizedBox(height: 15),
                      Text(
                        'Watchlist not found',
                        style: kHeading6.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 50),
                    ],
                  ),
                );
              }
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = result[index];
                  return TVCard(tv);
                },
                itemCount: result.length,
              );
            } else {
              return Center(
                key: Key('error_message'),
                child: Text(data.message),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
