import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_demo/models/movie.dart';

class APIService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://api.themoviedb.org/3'));

  final String? apiKey = dotenv.env['TMDB_API_KEY'];

  Future<List<Movie>> getPopularMovies() async {
    try {
      final response = await _dio.get(
        '/movie/popular',
        queryParameters: {'api_key': apiKey, 'language': 'ko-KR'},
      );

      log('영화 정보를 불러옴', name: 'Get Movies Api');

      final results = response.data['results'] as List;

      log('${results.length}의 결과 변환 완료', name: 'Get Movies Api');
      return results.map((json) => Movie.fromJson(json)).toList();
    } catch (e) {
      log('$e');
      rethrow;
    }
  }
}
