import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/tv/popular_tv_notifier.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PopularTVPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-tv';

  const PopularTVPage({Key? key}) : super(key: key);

  @override
  State<PopularTVPage> createState() => _PopularTVPageState();
}

class _PopularTVPageState extends State<PopularTVPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<PopularTVNotifier>(context, listen: false)
            .fetchPopularTVShows());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<PopularTVNotifier>(
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
