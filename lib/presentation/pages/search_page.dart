import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/movie_search_notifier.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget {
  static const ROUTE_NAME = '/search';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Search'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                onSubmitted: (query) {
                  Provider.of<MovieSearchNotifier>(context, listen: false)
                      .fetchMovieSearch(query);
                },
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
              Consumer<MovieSearchNotifier>(
                builder: (context, data, child) {
                  if (data.searchResult.isEmpty) {
                    return Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/search_not_found.png'),
                            SizedBox(height: 15),
                            Text(
                              'Movies not found',
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

                  if (data.state == RequestState.loading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (data.state == RequestState.loaded) {
                    final result = data.searchResult;
                    return Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemBuilder: (context, index) {
                          final movie = data.searchResult[index];
                          return MovieCard(movie);
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
      ),
    );
  }
}
