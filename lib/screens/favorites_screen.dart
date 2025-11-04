import 'package:flutter/material.dart';
import 'package:movie_demo/screens/detail_screen.dart';
import 'package:movie_demo/services/favorites_service.dart';

import '../models/movie.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late Future<List<Movie>> favoritesFuture;
  int? selectedGenreId;

  static const genreMap = {
    12: '모험',
    14: '판타지',
    16: '애니메이션',
    18: '드라마',
    27: '호러',
    28: '액션',
    35: '코미디',
    53: '스릴러',
    80: '범죄',
    878: 'SF',
    10402: '뮤직',
    10749: '로맨스',
    10752: '전쟁',
  };

  @override
  void initState() {
    super.initState();
    favoritesFuture = FavoritesService.getFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 28.0, right: 28.0, top: 28.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // Favorites
              Text(
                'Favorites',
                style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 12.0),

              // Genre Selector
              _buildGenreList(),

              SizedBox(height: 18.0),

              // Movie Posters
              Expanded(
                child: FutureBuilder<List<Movie>>(
                  future: favoritesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text('데이터를 불러오는 중 에러 발생: ${snapshot.error}'),
                      );
                    }

                    final List<Movie> favorites = snapshot.data ?? [];
                    final filteredMovies = selectedGenreId == null
                        ? favorites
                        : favorites
                              .where(
                                (movie) =>
                                    movie.genreIds.contains(selectedGenreId),
                              )
                              .toList();
                    if (favorites.isEmpty) {
                      return Center(child: Text('데이터가 없습니다'));
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        setState(() {
                          favoritesFuture = FavoritesService.getFavorites();
                        });
                        await favoritesFuture;
                      },
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          mainAxisSpacing: 16.0,
                          crossAxisSpacing: 8.0,
                        ),
                        itemCount: filteredMovies.length,
                        itemBuilder: (context, index) {
                          final Movie movie = filteredMovies[index];
                          return _buildFavoriteCard(movie);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenreList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: genreMap.entries
            .map(
              (genre) => Padding(
                padding: EdgeInsets.only(right: 4.0),
                child: _buildGenreContainer(genre.key, genre.value),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildGenreContainer(int genreId, String genre) {
    final isSelected = selectedGenreId == genreId;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGenreId = isSelected ? null : genreId;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          color: isSelected
              ? Theme.of(context).colorScheme.secondaryContainer.withAlpha(120)
              : Theme.of(context).colorScheme.secondaryContainer.withAlpha(20),
        ),
        child: Center(
          child: Text(
            genre,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteCard(Movie movie) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailScreen(movie: movie)),
        );
        // DetailScreen에서 돌아온 후 즐겨찾기 목록 새로고침
        setState(() {
          favoritesFuture = FavoritesService.getFavorites();
        });
      },
      child: Hero(
        tag: 'hero-movie-${movie.id}',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: Image.network(
            'https://image.tmdb.org/t/p/w500/${movie.posterPath}',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
