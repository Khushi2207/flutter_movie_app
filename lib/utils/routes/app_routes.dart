import 'package:flutter/material.dart';

import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/saved_movies/saved_movies_screen.dart';

class AppRoutes {
  static const String savedMovies = '/savedMovies';
  static const String homeScreen = '/homeScreen';

  static final Map<String, WidgetBuilder> routes = {
    savedMovies: (context) => const SavedMoviesScreen(),
    homeScreen: (context) => const HomeScreen(),
  };
}
