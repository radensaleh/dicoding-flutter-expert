import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/tv/top_rated_tv_notifier.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopRatedTVPage extends StatefulWidget {
  static const ROUTE_NAME = '/top-rated-tv';

  const TopRatedTVPage({Key? key}) : super(key: key);

  @override
  State<TopRatedTVPage> createState() => _TopRatedTVPageState();
}

class _TopRatedTVPageState extends State<TopRatedTVPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<TopRatedTVNotifier>(context, listen: false)
            .fetchTopRatedTVShows());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Rated TV Shows'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<TopRatedTVNotifier>(
          builder: (context, data, child) {
            final state = data.state;
            if (state == RequestState.loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state == RequestState.loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = data.tvShows[index];
                  return TVCard(tv);
                },
                itemCount: data.tvShows.length,
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
}
