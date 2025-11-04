import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_demo/models/movie.dart';
import 'package:movie_demo/services/api_service.dart';
import 'package:movie_demo/utils/debouncer.dart';
import 'package:movie_demo/widgets/my_movie_card.dart';

enum SearchMode { popular, searching }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final APIService apiService = APIService();
  final controller = TextEditingController();
  late Future<List<Movie>> moviesFuture;
  final Debouncer debouncer = Debouncer();
  SearchMode searchMode = SearchMode.popular;

  @override
  void initState() {
    super.initState();
    moviesFuture = apiService.getPopularMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                _buildSearchBar(),

                SizedBox(height: 24.0),

                // Popular
                Text(
                  searchMode == SearchMode.popular ? '인기 영화' : '검색 결과',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),

                SizedBox(height: 4.0),

                Expanded(
                  child: FutureBuilder<List<Movie>>(
                    future: moviesFuture,
                    builder: (context, snapshot) {
                      // loading state
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      // error state
                      if (snapshot.hasError) {
                        return Center(child: Text('에러 발생: ${snapshot.error}'));
                      }

                      // 데이터 상태
                      final movies = snapshot.data;
                      if (movies == null || movies.isEmpty) {
                        return Center(
                          child: Text(
                            searchMode == SearchMode.popular
                                ? '인기 영화 정보를 불러오지 못 했습니다.'
                                : '검색된 결과가 없습니다.',
                          ),
                        );
                      }

                      return RefreshIndicator(
                        onRefresh: () {
                          setState(() {
                            if (searchMode == SearchMode.searching &&
                                controller.text.isNotEmpty) {
                              moviesFuture = apiService.getSearchedMovie(
                                controller.text,
                              );
                            } else {
                              moviesFuture = apiService.getPopularMovies();
                            }
                          });
                          return moviesFuture;
                        },
                        child: ListView.builder(
                          itemCount: movies.length,
                          itemBuilder: (context, index) =>
                              MyMovieCard(movie: movies[index]),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Theme.of(context).colorScheme.primary.withAlpha(50),
      ),
      child: Row(
        children: [
          // Back Button
          GestureDetector(
            onTap: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  controller.clear();
                  searchMode = SearchMode.popular;
                  moviesFuture = apiService.getPopularMovies();
                });
              }
            },
            child: Container(
              color: Colors.transparent,
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(
                CupertinoIcons.back,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ),

          // TextField
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: (query) {
                debouncer(() {
                  setState(() {
                    if (query.isEmpty) {
                      searchMode = SearchMode.popular;
                      moviesFuture = apiService.getPopularMovies();
                    } else {
                      searchMode = SearchMode.searching;
                      moviesFuture = apiService.getSearchedMovie(query);
                    }
                  });
                });
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search',
                hintStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ),

          // Search Button
          GestureDetector(
            onTap: () {
              final query = controller.text;

              setState(() {
                if (query.isEmpty) {
                  searchMode = SearchMode.popular;
                  moviesFuture = apiService.getPopularMovies();
                } else {
                  searchMode = SearchMode.searching;
                  moviesFuture = apiService.getSearchedMovie(query);
                }
              });
            },
            child: Container(
              color: Colors.transparent,
              padding: const EdgeInsets.only(left: 8.0),
              child: Icon(
                Icons.search,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                size: 26.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}
