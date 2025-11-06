import 'package:flutter/material.dart';
import 'package:movie_demo/screens/detail_screen.dart';
import 'package:movie_demo/services/api_service.dart';
import 'package:movie_demo/services/favorites_service.dart';

import '../main.dart';
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
          padding: EdgeInsets.only(
            left: mq.width * 0.05,
            right: mq.width * 0.05,
            top: mq.height * 0.03,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // Favorites Text
              Text(
                'Favorites',
                style: TextStyle(
                  fontSize: mq.width * 0.07,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: mq.width * 0.015),

              // Genre Selector
              _buildGenreList(),

              SizedBox(height: mq.width * 0.03),

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
                          mainAxisSpacing: mq.height * 0.02,
                          crossAxisSpacing: mq.width * 0.02,
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
                padding: EdgeInsets.only(right: mq.width * 0.02),
                child: _buildGenreContainer(genre.key, genre.value),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildGenreContainer(int genreId, String genre) {
    final isSelected = selectedGenreId == genreId;
    final verticalPadding = mq.height * 0.007;
    final horizontalPadding = mq.width * 0.03;
    final borderRadius = mq.width * 0.075;
    final fontSize = mq.width * 0.032;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGenreId = isSelected ? null : genreId;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding,
          horizontal: horizontalPadding,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: isSelected
              ? Theme.of(context).colorScheme.primaryContainer.withAlpha(160)
              : Theme.of(context).colorScheme.primaryContainer.withAlpha(30),
        ),
        child: Center(
          child: Text(
            genre,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimaryContainer.withAlpha(
                isSelected ? 255 : 120,
              ),
              fontWeight: FontWeight.w600,
              fontSize: fontSize,
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
          borderRadius: BorderRadius.circular(mq.width * 0.03),
          child: Image.network(
            '${APIService.baseImageUrl}/${movie.posterPath}',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
