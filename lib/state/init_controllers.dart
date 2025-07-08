import 'package:get/get.dart';

import 'controllers/bookmark_movie_controller.dart';

Future<void> initControllers() async {
  // initialising getx controllers
  Get.lazyPut(() => BookmarkMovieController());
}
