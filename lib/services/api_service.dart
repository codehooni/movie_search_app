import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_demo/models/movie.dart';

class APIService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://api.themoviedb.org/3'));

  final String? apiKey = dotenv.env['TMDB_API_KEY'];

  // 인기 영화 불러오기
  Future<List<Movie>> getPopularMovies() async {
    try {
      final response = await _dio.get(
        '/movie/popular',
        queryParameters: {'api_key': apiKey, 'language': 'ko-KR'},
      );

      log('인기 영화 정보를 불러옴', name: 'Movie Api');

      final results = response.data['results'] as List;

      return results.map((json) => Movie.fromJson(json)).toList();
    } catch (e) {
      log('인기 영화 정보를 불러오는 중 오류 발생: $e');
      rethrow;
    }
  }

  // 검색된 영화 불러오기
  Future<List<Movie>> getSearchedMovie(String query) async {
    try {
      final response = await _dio.get(
        '/search/movie',
        queryParameters: {
          'query': query,
          'api_key': apiKey,
          'language': 'ko-KR',
        },
      );
      log('검색된 영화 정보를 불러옴', name: 'Movie Api');

      final result = response.data['results'] as List;

      return result.map((json) => Movie.fromJson(json)).toList();
    } catch (e) {
      log('검색된 영화 정보를 불러오는 중 오류 발생: $e');
      rethrow;
    }
  }
}
