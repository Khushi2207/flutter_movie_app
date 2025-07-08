import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_application_2/utils/app_constants.dart';
import 'package:share_plus/share_plus.dart';

import '../../../data/models/movie_model.dart';
import '../../../state/controllers/bookmark_movie_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/display_methods.dart';
import '../common_widgets/vertical_space.dart';

class MovieDetailsScreen extends StatefulWidget {
  final MovieModel movie;

  const MovieDetailsScreen({super.key, required this.movie});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  final BookmarkMovieController _bookmarkService = Get.find();

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight = DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth = DisplayMethods(context: context).getVariablePixelWidth();
    double textFontMultiplier = DisplayMethods(context: context).getTextFontMultiplier();
    double pixelMultiplier = DisplayMethods(context: context).getPixelMultiplier();

    final isBookmarked = _bookmarkService.isBookmarked(widget.movie);

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: AppColors.transparent,
          elevation: 0,
          leadingWidth: 70,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_outlined,
              color: AppColors.white,
              size: 24 * pixelMultiplier,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: null,
          actions: [
            IconButton(
              icon: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border),
              color: AppColors.white,
              onPressed: () {
                setState(() {
                  if (isBookmarked) {
                    _bookmarkService.removeBookmark(widget.movie);
                  } else {
                    _bookmarkService.addBookmark(widget.movie);
                  }
                });
              },
            ),
            Padding(
              padding: EdgeInsets.only(right: 8.0 * variablePixelWidth),
              child: IconButton(
                icon: const Icon(Icons.share),
                color: AppColors.white,
                onPressed: () {
                  final fakeDeepLink = 'myapp://movie?id=${widget.movie.id}';
                  Share.share('Check out this movie: ${widget.movie.title}\n$fakeDeepLink');
                },
              ),
            ),
          ],
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              '${AppConstants.imageBaseUrl}${widget.movie.backdropPath}',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: AppColors.grey,
                child: const Center(child: Icon(Icons.broken_image, color: Colors.white, size: 50)),
              ),
            ),
            Container(
              color: Colors.black.withOpacity(0.5), // Optional dark overlay for better text contrast
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20 * variablePixelWidth, vertical: 20 * variablePixelHeight),
              child: Column(
                children: [
                  const Spacer(),
                  Text(widget.movie.title, style: TextStyle(color: AppColors.white, fontSize: 22 * textFontMultiplier, fontWeight: FontWeight.bold)),
                  const VerticalSpace(height: 8),
                  Text('Release Date: ${widget.movie.releaseDate}', style: const TextStyle(color: AppColors.grey)),
                  const VerticalSpace(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...List.generate(5, (index) {
                        double ratingOutOf5 = (widget.movie.voteAverage / 2);
                        if (index < ratingOutOf5.floor()) {
                          return const Icon(Icons.star, color: Colors.amber, size: 20);
                        } else if (index < ratingOutOf5) {
                          return const Icon(Icons.star_half, color: Colors.amber, size: 20);
                        } else {
                          return const Icon(Icons.star_border, color: Colors.amber, size: 20);
                        }
                      }),
                      const SizedBox(width: 8),
                      Text(
                        '${(widget.movie.voteAverage / 2).toStringAsFixed(1)} / 5',
                        style: const TextStyle(color: AppColors.grey),
                      ),
                    ],
                  ),
                  const VerticalSpace(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        widget.movie.overview,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 16 * textFontMultiplier,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
