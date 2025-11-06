import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_demo/models/movie.dart';
import 'package:movie_demo/services/api_service.dart';
import 'package:movie_demo/utils/debouncer.dart';
import 'package:movie_demo/widgets/my_movie_card.dart';

import '../main.dart';

/*
  검색 모드
  - popular: 인기 영화 표시
  - searching: 검색 결과 표시
*/
enum MovieState { popular, searching }

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // API Service instance
  final APIService apiService = APIService();

  // 검색 입력 필드 컨트롤러
  final controller = TextEditingController();

  // 검색 Focus 해제를 위해
  FocusNode textFocus = FocusNode();

  // 검색 입력 디바운서 (500ms 지연)
  final Debouncer debouncer = Debouncer();

  // 현재 상태 (인기, 검색)
  MovieState movieState = MovieState.popular;

  // ScrollController 무한 스크롤
  final ScrollController _scrollController = ScrollController();
  List<Movie> movies = [];
  int currentPage = 1;
  bool isLoading = false;
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

  Future<void> _loadMovies({int page = 1}) async {
    try {
      setState(() {
        isLoading = true;
      });

      List<Movie> newMovies;

      // 인기 모드
      if (movieState == MovieState.popular) {
        newMovies = await apiService.getPopularMovies(page: page);
      }
      // 검색 모드
      else {
        final query = controller.text;
        newMovies = await apiService.getSearchedMovie(query, page: page);
      }

      setState(() {
        hasMore = newMovies.length >= 20;
        currentPage = page;
        movies = page == 1 ? [] : movies;
        movies.addAll(newMovies);
      });
    } catch (e) {
      log('$e', name: 'Load Data in Home Screen');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadMore() async {
    if (isLoadingMore || !hasMore) return;

    try {
      setState(() {
        isLoadingMore = true;
      });

      final int nextPage = currentPage + 1;
      await _loadMovies(page: nextPage);
    } catch (e) {
      log('$e', name: 'Load Data in Home Screen');
    } finally {
      setState(() {
        isLoadingMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = mq.width * 0.05;
    final verticalPadding = mq.height * 0.005;

    return GestureDetector(
      onTap: textFocus.unfocus,
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Bar
                  _buildSearchBar(),

                  SizedBox(height: mq.height * 0.022),

                  // Section Title (조건부 렌더링)
                  Text(
                    movieState == MovieState.popular ? '인기 영화' : '검색 결과',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: mq.height * 0.005),

                  // Movie List (FutureBuilder로 비동기 데이터 처리)
                  Expanded(
                    child: isLoading && !isLoadingMore
                        // 로딩 중 화면
                        ? _buildWaitingScreen()
                        : movies.isEmpty
                        // 데이터가 없을 때
                        ? _buildEmptyScreen()
                        // 기본
                        : RefreshIndicator(
                            onRefresh: _loadMovies,
                            child: GestureDetector(
                              onPanDown: (_) {
                                textFocus.unfocus();
                              },
                              child: ListView.builder(
                                controller: _scrollController,
                                itemCount:
                                    movies.length + (isLoadingMore ? 1 : 0),
                                itemBuilder: (context, index) {
                                  // 무한 스크롤 중 로딩 중 표시
                                  if (index == movies.length) {
                                    return Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(
                                          mq.height * 0.02,
                                        ),
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  }

                                  final movie = movies[index];
                                  return MyMovieCard(movie: movie);
                                },
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Build Search bar Widget
  Widget _buildSearchBar() {
    final verticalPadding = mq.height * 0.005;
    final horizontalPadding = mq.width * 0.03;
    final borderRadius = mq.width * 0.03;
    final iconSize = mq.width * 0.065;
    final iconPadding = mq.width * 0.02;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: verticalPadding,
        horizontal: horizontalPadding,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: Theme.of(context).colorScheme.primaryContainer.withAlpha(100),
      ),
      child: Row(
        children: [
          // Back Button (검색 취소 기능)
          GestureDetector(
            onTap: _onBackButton,
            child: Container(
              color: Colors.transparent,
              padding: EdgeInsets.only(right: iconPadding),
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
              focusNode: textFocus,
              // 입력이 변경될 때마다 호출 (디바운싱 적용)
              onChanged: (_) => debouncer(() {
                final query = controller.text;

                // 쿼리가 비어 있으면 인기 영화 모드로 전환
                if (query.isEmpty) {
                  movieState = MovieState.popular;
                  textFocus.unfocus();
                }
                // 검색 모드 이면서 인기 영화 상태 일때 서치 상태로 변환
                else if (movieState != MovieState.searching) {
                  movieState = MovieState.searching;
                }
                // 검색 모드 이면서 이미 서치 상태일 때 넘어가기

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
              padding: EdgeInsets.only(left: iconPadding),
              child: Icon(
                Icons.search,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                size: iconSize,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onBackButton() {
    // 검색어가 있을 때만 동작
    if (controller.text.isNotEmpty) {
      setState(() {
        textFocus.unfocus();
        controller.clear(); // 검색어 지우기
      });
      _loadMovies();
    }
    setState(() {
      movieState = MovieState.popular;
    });
    _loadMovies();
  }

  Widget _buildWaitingScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: mq.height * 0.02),
          Text(
            movieState == MovieState.popular ? '인기 영화를 불러오는 중...' : '검색 중...',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withAlpha(160),
              fontSize: mq.width * 0.035,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            movieState == MovieState.popular
                ? '인기 영화 목록을 불러오지 못 했습니다.'
                : '검색 목록이 없습니다.',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withAlpha(160),
              fontSize: mq.width * 0.04,
            ),
          ),
          SizedBox(height: mq.height * 0.02),
          ElevatedButton.icon(
            onPressed: _loadMovies,
            label: Text('다시 시도'),
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    debouncer.cancel();
    _scrollController.dispose();
    textFocus.dispose();
  }
}
