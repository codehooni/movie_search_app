import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_demo/models/movie.dart';
import 'package:movie_demo/services/api_service.dart';
import 'package:movie_demo/utils/debouncer.dart';
import 'package:movie_demo/widgets/my_movie_card.dart';

/*
  검색 모드
  - popular: 인기 영화 표시
  - searching: 검색 결과 표시
*/
enum SearchMode { popular, searching }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // API Service instance
  final APIService apiService = APIService();

  // 검색 입력 필드 컨트롤러
  final controller = TextEditingController();

  // 영화 데이터를 담는 Future
  late Future<List<Movie>> moviesFuture;

  // 검색 입력 디바운서 (500ms 지연)
  final Debouncer debouncer = Debouncer();

  // Current Searching mode State
  SearchMode searchMode = SearchMode.popular;

  @override
  void initState() {
    super.initState();

    // 초기 화면에서 인기 영화 로드
    moviesFuture = apiService.getPopularMovies();
  }

  // 검색어 입력에 따라 영화 데이터 가져오는 메서드
  // 검색어 있을 때: 인기 영화
  // 검색어 없을 때: 검색어로 검색
  void fetchMovies() {
    try {
      final query = controller.text;
      setState(() {
        // 검색어가 없으면 인기 영화 표시
        if (query.isEmpty) {
          searchMode = SearchMode.popular;
          moviesFuture = apiService.getPopularMovies();
        }
        // 검색어가 있으면 검색 실행
        else {
          searchMode = SearchMode.searching;
          moviesFuture = apiService.getSearchedMovie(query);
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('검색 중 오류가 발생했습니다.'),
          backgroundColor: Colors.red,
          action: SnackBarAction(
            label: '다시 시도',
            textColor: Colors.white,
            onPressed: fetchMovies,
          ),
        ),
      );
    }
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

                // Section Title (조건부 렌더링)
                Text(
                  searchMode == SearchMode.popular ? '인기 영화' : '검색 결과',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),

                SizedBox(height: 4.0),

                // Movie List (FutureBuilder로 비동기 데이터 처리)
                Expanded(
                  child: FutureBuilder<List<Movie>>(
                    future: moviesFuture,
                    builder: (context, snapshot) {
                      // loading state: API 호출 중
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        _buildWaitingScreen();
                      }

                      // error state: API 호출 실패
                      if (snapshot.hasError) {
                        return _buildErrorScreen(snapshot);
                      }

                      // data state: API 호출 성공
                      final movies = snapshot.data;

                      // 빈 데이터 처리 (조건부 렌더링)
                      if (movies == null || movies.isEmpty) {
                        return Center(
                          child: Text(
                            searchMode == SearchMode.popular
                                ? '인기 영화 정보를 불러오지 못 했습니다.'
                                : '검색된 결과가 없습니다.',
                          ),
                        );
                      }

                      // Pull-to-Refresh 기능이 있는 영화 리스트
                      return RefreshIndicator(
                        // 새로고침
                        onRefresh: () {
                          fetchMovies();
                          return moviesFuture;
                        },
                        // 영화 카드 리스트
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

  // Build Search bar Widget
  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Theme.of(context).colorScheme.primary.withAlpha(50),
      ),
      child: Row(
        children: [
          // Back Button (검색 취소 기능)
          GestureDetector(
            onTap: () {
              // 검색어가 있을 때만 동작
              if (controller.text.isNotEmpty) {
                setState(() {
                  controller.clear(); // 검색어 지우기
                });
                fetchMovies();
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

          // TextField for Searching
          Expanded(
            child: TextField(
              controller: controller,
              // 입력이 변경될 때마다 호출 (디바운싱 적용)
              onChanged: (_) => debouncer(() {
                fetchMovies();
              }),
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
            onTap: fetchMovies,
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

  Widget _buildWaitingScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            searchMode == SearchMode.popular ? '인기 영화를 불러오는 중...' : '검색 중...',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // When there is an error, Show Refresh Button
  Widget _buildErrorScreen(AsyncSnapshot snapshot) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 60, color: Colors.red),
          SizedBox(height: 16),
          Text(
            _getErrorMessage(snapshot.error),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: fetchMovies,
            icon: Icon(Icons.refresh),
            label: Text('다시 시도'),
          ),
        ],
      ),
    );
  }

  // 에러 타입별 사용자 친화적 메시지 반환
  String _getErrorMessage(Object? error) {
    if (error.toString().contains('SocketException')) {
      return '인터넷 연결을 확인해주세요.';
    } else if (error.toString().contains('TimeoutException')) {
      return '요청 시간이 초과되었습니다.\n잠시 후 다시 시도해주세요.';
    } else if (error.toString().contains('401')) {
      return 'API 인증에 실패했습니다.';
    } else if (error.toString().contains('404')) {
      return '요청한 정보를 찾을 수 없습니다.';
    } else if (error.toString().contains('500')) {
      return '서버 오류가 발생했습니다.';
    } else {
      return '오류가 발생했습니다.\n${error.toString()}';
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}
