import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import 'app_config.dart';
import 'data/models/movie_model.dart';
import 'presentation/view/app.dart';
import 'state/init_controllers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(MovieModelAdapter());
  await Hive.openBox<List<MovieModel>>('movieCache');
  initControllers();
  AppConfig.create(
      appName: "movie application",
      flavor: Flavor.dev,
  );
  runApp(const MainApp());
}
