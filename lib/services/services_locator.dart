import 'package:get_it/get_it.dart';

import '../data/datasource/movie_remote_data_source.dart';

final sl = GetIt.instance;

class ServicesLocator {
  void init() {

    /// DATA SOURCE
    sl.registerLazySingleton<BaseMovieRemoteDataSource>(
        () => MovieRemoteDataSource());
  }
}
