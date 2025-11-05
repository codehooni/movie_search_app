import 'dart:developer';

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
  // 검색 입력 디바운서 (500ms 지연)
  final Debouncer debouncer = Debouncer();
  // 현재 상태 (인기, 검색)
  SearchMode searchMode = SearchMode.popular;

  // ScrollController 무한 스크롤
  final ScrollController _scrollController = ScrollController();
  List<Movie> movies = [];
  int currentPage = 1;
  bool isLoadingMore = false;
  bool hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadMovies();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= // 현재 스크롤 위치
        _scrollController.position.maxScrollExtent - 200) {
      // 최대 스크롤 - 200px
      if (!isLoadingMore && hasMore) {
        // 로딩 중이 아니고 더 가져올 데이터가 있을 때
        _loadMore();
      }
    }
  }

  // 검색어 입력에 따라 영화 데이터 가져오는 메서드
  // 검색어 있을 때: 인기 영화
  // 검색어 없을 때: 검색어로 검색
  Future<void> _loadMovies() async {
    setState(() {
      movies = [];
      currentPage = 1;
      hasMore = true;
    });

    try {
      final query = controller.text;
      List<Movie> newMovies;

      setState(() async {
        // 검색어가 없으면 인기 영화 표시
        if (query.isEmpty) {
          searchMode = SearchMode.popular;
          newMovies = await apiService.getPopularMovies();
        }
        // 검색어가 있으면 검색 실행
        else {
          searchMode = SearchMode.searching;
          newMovies = await apiService.getSearchedMovie(query);
        }

        setState(() {
          movies = newMovies;
          hasMore = newMovies.length >= 20;
        });
      });
    } catch (e) {
      log('검색 중 오류 발생 ');
    }
  }

  Future<void> _loadMore() async {
    if (isLoadingMore || !hasMore) return;

    setState(() {
      isLoadingMore = true;
    });

    try {
      final query = controller.text;
      final nextPage = currentPage + 1;
      List<Movie> newMovies;

      if (query.isEmpty) {
        newMovies = await apiService.getPopularMovies(page: nextPage);
      } else {
        newMovies = await apiService.getSearchedMovie(query, page: nextPage);
      }

      setState(() {
        currentPage = nextPage;
        movies.addAll(newMovies);
        hasMore = newMovies.length >= 20;
        isLoadingMore = false;
      });
    } catch (e) {
      setState(() {
        isLoadingMore = false;
      });
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
                  child: movies.isEmpty
                      ? Center(child: CircularProgressIndicator())
                      :
                        // Pull-to-Refresh 기능이 있는 영화 리스트
                        RefreshIndicator(
                          // 새로고침
                          onRefresh: _loadMovies,
                          // 영화 카드 리스트
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount: movies.length + (isLoadingMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == movies.length) {
                                return Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              return MyMovieCard(movie: movies[index]);
                            },
                          ),
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
                _loadMovies();
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
                _loadMovies();
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
            onTap: _loadMovies,
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
            onPressed: _loadMovies,
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
    debouncer.cancel();
    _scrollController.dispose();
  }
}
