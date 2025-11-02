import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_demo/models/movie.dart';
import 'package:movie_demo/widgets/my_movie_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final apiKey = dotenv.env['TMDB_API_KEY'];
  final controller = TextEditingController();

  // dummy data
  final List<Movie> movieList = [
    Movie(
      id: 507244,
      title: "애프터번",
      posterPath: "/xR0IhVBjbNU34b8erhJCgRbjXo3.jpg",
      genreIds: [878, 28, 35],
      voteAverage: 6.786,
      overview:
          "인류가 사라진 땅, 보물 사냥꾼의 마지막 의뢰\n태양폭풍으로 전 세계의 기술과 문명이 붕괴된 지 10년. 생존자들은 폐허 속에서 잔존한 유물과 자원을 두고 치열한 경쟁을 벌인다.",
      releaseDate: "2025-08-20",
      originalLanguage: "en",
      backdropPath: "/kHOfxq7cMTXyLbj0UmdoGhT540O.jpg",
      adult: false,
      popularity: 367.5637,
    ),
    Movie(
      id: 755898,
      title: "우주전쟁",
      posterPath: "/yvirUYrva23IudARHn3mMGVxWqM.jpg",
      genreIds: [878, 53],
      voteAverage: 4.3,
      overview:
          "전설적인 동명 소설을 새롭게 재해석한 이번 작품은 거대한 침공의 서막을 알린다. 에바 롱고리아와 전설적인 래퍼이자 배우 아이스 큐브가 합류해 기술과 감시, 사생활이라는 현대적 주제를 아우르는 짜릿한 우주급 모험을 선보인다.",
      releaseDate: "2025-07-29",
      originalLanguage: "en",
      backdropPath: "/iZLqwEwUViJdSkGVjePGhxYzbDb.jpg",
      adult: false,
      popularity: 287.5437,
    ),
    Movie(
      id: 1156594,
      title: "우리의 잘못",
      posterPath: "/yCbT1nKemh1AuQgdbns5Cf1RmRj.jpg",
      genreIds: [10749, 18],
      voteAverage: 7.58,
      overview:
          "헤어진 후 오랫동안 기다려온 노아와 닉은 예나와 라이온의 결혼식에서 재회한다. 노아를 용서하지 못하는 닉의 마음은 넘을 수 없는 장벽처럼 단단하다. 사랑이 원망보다 더 강해질 수 있을까?",
      releaseDate: "2025-10-15",
      originalLanguage: "es",
      backdropPath: "/7QirCB1o80NEFpQGlQRZerZbQEp.jpg",
      adult: false,
      popularity: 228.5306,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Center(
            child: Column(
              children: [
                _buildSearchBar(),
                Expanded(
                  child: ListView.builder(
                    itemCount: movieList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return MyMovieCard(movie: movieList[index]);
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
            onTap: () {},
            child: Padding(
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
            onTap: () {},
            child: Padding(
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
}
