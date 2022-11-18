import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/tv/tv_list_notifier.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OnTheAirTVPage extends StatefulWidget {
  static const ROUTE_NAME = '/on-the-air-tv';

  const OnTheAirTVPage({Key? key}) : super(key: key);

  @override
  State<OnTheAirTVPage> createState() => _OnTheAirTVPageState();
}

class _OnTheAirTVPageState extends State<OnTheAirTVPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<TVListNotifier>(context, listen: false)
        .fetchOnTheAirTVShows());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TV Shows'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<TVListNotifier>(
          builder: (context, data, child) {
            final state = data.onTheAirTVState;
            if (state == RequestState.loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state == RequestState.loaded) {
              return ListView.builder(
                itemCount: data.onTheAirTVShows.length,
                itemBuilder: (context, index) {
                  final tv = data.onTheAirTVShows[index];
                  return TVCard(tv);
                },
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
