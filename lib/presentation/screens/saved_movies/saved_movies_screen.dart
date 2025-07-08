import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../state/controllers/bookmark_movie_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/display_methods.dart';
import '../home/widgets/movie_card.dart';

class SavedMoviesScreen extends StatefulWidget {
  const SavedMoviesScreen({super.key});

  @override
  State<SavedMoviesScreen> createState() => _SavedMoviesScreenState();
}

class _SavedMoviesScreenState extends State<SavedMoviesScreen> {
  final BookmarkMovieController bookmarkMovieController = Get.find();

  @override
  void initState() {
    super.initState();
    bookmarkMovieController.loadBookmarks();
  }

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight = DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth = DisplayMethods(context: context).getVariablePixelWidth();
    double pixelMultiplier = DisplayMethods(context: context).getPixelMultiplier();

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.black,
        appBar: AppBar(
          backgroundColor: AppColors.transparent,
          leadingWidth: 80,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_outlined,
              color: AppColors.white,
              size: 24 * pixelMultiplier,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: const Text('Bookmarked Movies', style: TextStyle(color: AppColors.white),),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 8.0 * variablePixelWidth),
              child: Obx(() {
                final isDisabled = bookmarkMovieController.bookmarkedMovies.isEmpty;

                return IconButton(
                  icon: Icon(Icons.delete_forever, color: isDisabled ? AppColors.grey : AppColors.white),
                  tooltip: 'Clear All',
                  onPressed: isDisabled ? null : _showClearConfirmation,
                );
              }),
            )
          ],
        ),
        body: Obx(() {
          final savedMovies = bookmarkMovieController.bookmarkedMovies;
      
          if(bookmarkMovieController.isLoading.value) {
            return const Center(child: CircularProgressIndicator(),);
          } else if(bookmarkMovieController.error.isNotEmpty) {
            return Center(child: Text(bookmarkMovieController.error.value),);
          } else if (savedMovies.isEmpty) {
            return const Center(child: Text('No saved movies yet!', style: TextStyle( color: AppColors.white),));
          }

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 14 * variablePixelWidth,vertical: 14 * variablePixelHeight),
            child: GridView.builder(
              itemCount: savedMovies.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.58,
              ),
              itemBuilder: (_, index) => MovieCard(
                movie: savedMovies[index],
                imageHeight: 200 * variablePixelHeight,
                imageWidth: double.infinity,
              ),
            ),
          );
        }),
      ),
    );
  }

  void _showClearConfirmation() {
    double textFontMultiplier = DisplayMethods(context: context).getTextFontMultiplier();
    double pixelMultiplier = DisplayMethods(context: context).getPixelMultiplier();
    double variablePixelWidth = DisplayMethods(context: context).getVariablePixelWidth();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.black,
        titleTextStyle: TextStyle(color: AppColors.white, fontSize: 18 * textFontMultiplier, fontWeight: FontWeight.bold),
        contentTextStyle: TextStyle(color: AppColors.white, fontSize: 16 * textFontMultiplier),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20 * pixelMultiplier),
          side: BorderSide(color: AppColors.lightPurple, width: 1.5 * variablePixelWidth),
        ),
        title: const Text('Clear All Bookmarks?'),
        content: const Text('Are you sure you want to remove all saved movies?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: AppColors.lightPurple)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.lightPurple,
              foregroundColor: AppColors.white,
            ),
            onPressed: () async {
              Navigator.pop(context);
              await bookmarkMovieController.clearBookmarks();
            },
            child: const Text('Clear All', style: TextStyle(color: AppColors.black),),
          ),
        ],
      ),
    );
  }
}
