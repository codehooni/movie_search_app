import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:movie_demo/models/movie.dart';

class FavoritesService {
  static const String _favoritesKey = 'favorites';

  static Future<void> addFavorite(Movie movie) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List<Movie> favorites = await getFavorites();

    // 중복 제거
    if (!favorites.any((otherMovie) => otherMovie.id == movie.id)) {
      favorites.add(movie);

      final jsonList = favorites.map((m) => jsonEncode(m.toJson())).toList();
      await prefs.setStringList(_favoritesKey, jsonList);
    }
  }

  static Future<void> removeFavorite(int movieId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List<Movie> favorites = await getFavorites();
    favorites.removeWhere((otherMovie) => otherMovie.id == movieId);

    final jsonList = favorites.map((m) => jsonEncode(m.toJson())).toList();
    await prefs.setStringList(_favoritesKey, jsonList);
  }

  static Future<List<Movie>> getFavorites() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_favoritesKey) ?? [];

    return jsonList.map((json) => Movie.fromJson(jsonDecode(json))).toList();
  }

  static Future<bool> isFavorite(int movieId) async {
    final favorites = await getFavorites();
    log(favorites.any((movie) => movie.id == movieId).toString());
    return favorites.any((movie) => movie.id == movieId);
  }
}
