import 'package:flutter/material.dart';

import '../../../../data/models/movie_model.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/display_methods.dart';
import 'movie_card.dart';

class AllMoviesGridScreen extends StatelessWidget {
  final String title;
  final List<MovieModel> movies;

  const AllMoviesGridScreen({super.key, required this.title, required this.movies});

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
          title: Text(title, style: const TextStyle(color: AppColors.white)),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.white, size: 24 * pixelMultiplier),
            onPressed: () => Navigator.pop(context),
          ),
          leadingWidth: 80,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12 * variablePixelWidth,vertical: 12 * variablePixelHeight),
          child: GridView.builder(
            itemCount: movies.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.58, // Adjust as needed
            ),
            itemBuilder: (_, index) => MovieCard(
              movie: movies[index],
              imageHeight: 200 * variablePixelHeight,
              imageWidth: double.infinity,
            ),
          ),
        ),
      ),
    );
  }
}
