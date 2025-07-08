import 'package:flutter/material.dart';
import 'package:movie_application_2/utils/app_colors.dart';
import '../../../../data/models/movie_model.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/display_methods.dart';
import '../../common_widgets/vertical_space.dart';
import '../../movie_detail/movie_detail_screen.dart';

class MovieCard extends StatelessWidget {
  final MovieModel movie;
  final double? imageHeight;
  final double? imageWidth;

  const MovieCard({
    super.key,
    required this.movie,
    this.imageHeight,
    this.imageWidth,
  });

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight = DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth = DisplayMethods(context: context).getVariablePixelWidth();
    double textFontMultiplier = DisplayMethods(context: context).getTextFontMultiplier();
    double pixelMultiplier = DisplayMethods(context: context).getPixelMultiplier();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => MovieDetailsScreen(movie: movie)),
        );
      },
      child: Container(
        width: (imageWidth ?? 120 * variablePixelWidth),
        margin: EdgeInsets.symmetric(horizontal: 8 * variablePixelWidth),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                '${AppConstants.imageBaseUrl}${movie.posterPath}',
                height: imageHeight ?? 300 * variablePixelHeight,
                width: imageWidth ?? 250 * variablePixelWidth,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: imageHeight ?? 300 * variablePixelHeight,
                  width: imageWidth ?? 250 * variablePixelWidth,
                  color: AppColors.grey,
                  child: Icon(Icons.broken_image, size: 40 * pixelMultiplier),
                ),
              ),
            ),
            const VerticalSpace(height: 10),
            Text(
              movie.title,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 18 * textFontMultiplier, fontWeight: FontWeight.w500, color: AppColors.white),
            ),
          ],
        ),
      ),
    );
  }
}
