import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/tv/tv_search_notifier.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchTVPage extends StatelessWidget {
  static const ROUTE_NAME = '/search-tv';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search TV Shows'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onSubmitted: (query) =>
                  Provider.of<TVSearchNotifier>(context, listen: false)
                      .fetchTVSearch(query),
              decoration: InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            SizedBox(height: 16),
            Text(
              'Search Result',
              style: kHeading6,
            ),
            Consumer<TVSearchNotifier>(
              builder: (context, data, child) {
                final state = data.state;
                if (state == RequestState.loading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state == RequestState.loaded) {
                  final result = data.searchResult;
                  if (result.isEmpty) {
                    return Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/search_not_found.png'),
                            SizedBox(height: 15),
                            Text(
                              'TV Show not found',
                              style: kHeading6.copyWith(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 50),
                          ],
                        ),
                      ),
                    );
                  }
                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemBuilder: (context, index) {
                        final tv = result[index];
                        return TVCard(tv);
                      },
                      itemCount: result.length,
                    ),
                  );
                } else {
                  return Expanded(
                    child: Container(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
