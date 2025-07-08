import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

import '../../data/datasource/movie_remote_data_source.dart';
import '../../data/models/movie_model.dart';

class BookmarkMovieController extends GetxController {
  var isLoading = false.obs;
  var error = ''.obs;

  MovieRemoteDataSource movieRemoteDataSource = MovieRemoteDataSource();

  final RxList<MovieModel> _bookmarkedMovies = <MovieModel>[].obs;
  List<MovieModel> get bookmarkedMovies => _bookmarkedMovies;

  static const String _bookmarkKey = 'bookmarked_movies';

  Future<void> loadBookmarks() async {
    isLoading(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? savedList = prefs.getStringList(_bookmarkKey);

      _bookmarkedMovies.clear();

      if (savedList != null) {
        for (var movieJson in savedList) {
          final Map<String, dynamic> jsonMap = json.decode(movieJson);
          _bookmarkedMovies.add(MovieModel.fromJson(jsonMap));
        }
      }
    } catch (e) {
      error(e.toString());
    }
    isLoading(false);
  }

  Future<void> saveBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> jsonList = _bookmarkedMovies.map((m) => json.encode(m.toJson())).toList();
    await prefs.setStringList(_bookmarkKey, jsonList);
  }

  Future<void> addBookmark(MovieModel movie) async {
    if (!_bookmarkedMovies.any((m) => m.id == movie.id)) {
      _bookmarkedMovies.add(movie);
      await saveBookmarks();
    }
  }

  Future<void> removeBookmark(MovieModel movie) async {
    _bookmarkedMovies.removeWhere((m) => m.id == movie.id);
    await saveBookmarks();
  }

  bool isBookmarked(MovieModel movie) {
    return _bookmarkedMovies.any((m) => m.id == movie.id);
  }

  Future<void> clearBookmarks() async {
    _bookmarkedMovies.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_bookmarkKey);
  }
}
