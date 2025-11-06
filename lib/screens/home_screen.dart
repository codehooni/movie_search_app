import 'package:flutter/material.dart';
import 'package:movie_demo/models/movie.dart';
import 'package:movie_demo/screens/detail_screen.dart';
import 'package:movie_demo/services/api_service.dart';
import 'package:movie_demo/widgets/my_movie_card.dart';

import '../main.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onTap;

  const HomeScreen({super.key, required this.onTap});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final APIService apiService = APIService();
  List<Movie> movies = [];
  int selectedMovieIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    movies = await apiService.getPopularMovies();

    setState(() {
      movies;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          _buildWelcomeCard(),
          if (movies.isNotEmpty)
            SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: AlignmentGeometry.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Theme.of(context).colorScheme.surface,
                      Theme.of(context).colorScheme.surface,
                    ],
                    //  0 ~  20% : 포스터
                    // 20 ~  40% : 그라데이션
                    // 40 ~ 100% : 배경
                    stops: [0.3, 0.6, 1.0],
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: mq.height * 0.35),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Card
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: mq.width * 0.05,
                          ),
                          child: MyMovieCard(
                            movie: movies[selectedMovieIndex],
                            isBig: true,
                            isHome: true,
                          ),
                        ),

                        SizedBox(height: mq.height * 0.02),

                        Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: mq.width * 0.05,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '인기 영화',
                                    style: TextStyle(
                                      fontSize: mq.width * 0.05,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: widget.onTap,
                                    child: Text(
                                      '더보기',
                                      style: TextStyle(
                                        fontSize: mq.width * 0.035,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: mq.height * 0.005),

                            SizedBox(
                              height: mq.height * 0.25,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: movies.length,
                                itemBuilder: (context, index) {
                                  // if (selectedMovieIndex == index) {
                                  //   return SizedBox();
                                  // }
                                  return _buildMoviePoster(index);
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMoviePoster(int index) {
    final movie = movies[index];

    return Padding(
      padding: EdgeInsets.only(
        left: index == 0 ? mq.width * 0.05 : 0,
        right: mq.width * 0.03,
      ),
      child: GestureDetector(
        onTap: () {
          if (selectedMovieIndex == index) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => DetailScreen(movie: movie)),
            );
          }
          setState(() {
            selectedMovieIndex = index;
          });
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(mq.width * 0.03),
          child: Image.network(
            '${APIService.baseImageUrl}/${movie.posterPath}',
            width: mq.width * 0.35,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildBackground() {
    if (movies.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }
    return Image.network(
      '${APIService.baseImageUrl}/${movies[selectedMovieIndex].posterPath}',
    );
  }

  Widget _buildWelcomeCard() {
    final verticalPadding = mq.height * 0.075;
    final horizontalPadding = mq.width * 0.05;
    final fontSize = mq.width * 0.038;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: Row(
        children: [
          Text(
            'Hi, Ceyhun👋',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
          ),

          Spacer(),

          Container(
            width: mq.width * 0.1,
            padding: EdgeInsets.all(mq.width * 0.02),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primaryContainer.withAlpha(80),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.notifications_none_rounded),
          ),

          SizedBox(width: mq.width * 0.02),

          Container(
            width: mq.width * 0.1,
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primaryContainer.withAlpha(80),
              shape: BoxShape.circle,
            ),
            child: Image.asset('assets/image/image.png', fit: BoxFit.cover),
          ),
        ],
      ),
    );
  }
}
