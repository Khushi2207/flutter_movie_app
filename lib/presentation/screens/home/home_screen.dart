import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:movie_application_2/presentation/screens/common_widgets/vertical_space.dart';

import '../../../data/datasource/movie_remote_data_source.dart';
import '../../../data/models/movie_model.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/display_methods.dart';
import '../../../utils/routes/app_routes.dart';
import '../movie_detail/movie_detail_screen.dart';
import 'widgets/all_movies_grid_screen.dart';
import 'widgets/movie_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late MovieRemoteDataSource _movieService;
  final TextEditingController _searchController = TextEditingController();
  List<MovieModel> _trendingMovies = [];
  List<MovieModel> _nowPlayingMovies = [];
  List<MovieModel> _searchResults = [];
  bool _isLoading = true;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _movieService = MovieRemoteDataSource();
    _fetchMovies();
  }

  void _fetchMovies() async {
    final trending = await _movieService.fetchTrendingMovies();
    final nowPlaying = await _movieService.fetchNowPlayingMovies();

    setState(() {
      _trendingMovies = trending;
      _nowPlayingMovies = nowPlaying;
      _isLoading = false;
    });
  }

  void _searchMovies(String query) {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
      });
      return;
    }

    final Map<int, MovieModel> uniqueMovies = {};

    for (var movie in [..._trendingMovies, ..._nowPlayingMovies]) {
      uniqueMovies[movie.id] = movie;
    }

    final results = uniqueMovies.values
        .where((movie) => movie.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    setState(() {
      _searchResults = results;
      _isSearching = true;
    });
  }

  void _handleDeepLink(String link) {
    if (kDebugMode) {
      print("Received deep link: $link");
    }

    final uri = Uri.tryParse(link);
    if (uri != null && uri.scheme == 'myapp' && uri.host == 'movie') {
      final movieId = int.tryParse(uri.queryParameters['id'] ?? '');
      if (movieId != null) {
        _navigateToSharedMovie(movieId);
      }
    }
  }

  void _navigateToSharedMovie(int movieId) {
    final allMovies = {..._trendingMovies, ..._nowPlayingMovies};
    final movie = allMovies.firstWhereOrNull((m) => m.id == movieId);

    if (movie != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => MovieDetailsScreen(movie: movie)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Movie not found.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight = DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth = DisplayMethods(context: context).getVariablePixelWidth();
    double pixelMultiplier = DisplayMethods(context: context).getPixelMultiplier();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.black,
          appBar: AppBar(
            backgroundColor: AppColors.transparent,
            title: Padding(
              padding: EdgeInsets.only(left: 8.0 * variablePixelWidth),
              child: const Text('Movies Application', style: TextStyle(color: AppColors.white ),),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 8.0 * variablePixelWidth),
                child: IconButton(
                  color: AppColors.white,
                  icon: const Icon(Icons.bookmark),
                  tooltip: 'Saved Movies',
                  onPressed: () {
                    //_handleDeepLink('myapp://movie?id=1233069');
                    Navigator.pushNamed(context, AppRoutes.savedMovies);
                  },
                ),
              ),
            ],
          ),
          body: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18 * variablePixelWidth, vertical: 18 * variablePixelHeight),
                child: TextField(
                  style: const TextStyle(color: AppColors.white),
                  controller: _searchController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.grey.withOpacity(0.2),
                    hintText: 'Search movies...',
                    prefixIcon: const Icon(Icons.search, color: AppColors.white),
                    suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: AppColors.white),
                          onPressed: () {
                            _searchController.clear();
                            _searchMovies('');
                          },
                        )
                      : null,
                    contentPadding: EdgeInsets.symmetric(vertical: 14 * variablePixelHeight),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30 * pixelMultiplier),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30 * pixelMultiplier),
                      borderSide: BorderSide(color: AppColors.lightPurple, width: 1.5 * variablePixelWidth),
                    ),
                  ),
                  onChanged: _searchMovies,
                ),
              ),
              Expanded(
                child: _isSearching ? _buildSearchResults() : _buildMovieLists(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    double variablePixelHeight = DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth = DisplayMethods(context: context).getVariablePixelWidth();

    if (_searchResults.isEmpty) {
      return const Center(child: Text('No movies found.', style: TextStyle( color: AppColors.white),));
    }

    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 8 * variablePixelWidth),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: _searchResults.length,
      itemBuilder: (_, index) => MovieCard(
        movie: _searchResults[index],
        imageHeight: 200 * variablePixelHeight,
        imageWidth: double.infinity,
      ),
    );
  }

  Widget _buildMovieLists() {
    double variablePixelWidth = DisplayMethods(context: context).getVariablePixelWidth();

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Trending Movies', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AllMoviesGridScreen(title: 'Trending Movies', movies: _trendingMovies)),
            );
          }),
          Padding(
            padding: EdgeInsets.only(left: 8.0 * variablePixelWidth, right: 8.0 * variablePixelWidth),
            child: _buildHorizontalList(_trendingMovies),
          ),
          const VerticalSpace(height: 10),
          _buildSectionTitle('Now Playing', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AllMoviesGridScreen(title: 'Now Playing', movies: _nowPlayingMovies)),
            );
          }),
          Padding(
            padding: EdgeInsets.only(left: 8.0 * variablePixelWidth, right: 8.0 * variablePixelWidth),
            child: _buildHorizontalList(_nowPlayingMovies),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, VoidCallback onSeeAll) {
    double variablePixelHeight = DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth = DisplayMethods(context: context).getVariablePixelWidth();
    double textFontMultiplier = DisplayMethods(context: context).getTextFontMultiplier();
    double pixelMultiplier = DisplayMethods(context: context).getPixelMultiplier();

    return GestureDetector(
      onTap: () {
        onSeeAll();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24 * variablePixelWidth, vertical: 15 * variablePixelHeight),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 22 * textFontMultiplier,
                fontWeight: FontWeight.bold,
                color: AppColors.lightPurple,
              ),
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward_ios, color: AppColors.white, size: 14 * pixelMultiplier),
              onPressed: onSeeAll,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHorizontalList(List<MovieModel> movies) {
    double variablePixelHeight = DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth = DisplayMethods(context: context).getVariablePixelWidth();

    final PageController controller = PageController(viewportFraction: 0.7);
    double currentPage = 0;

    return StatefulBuilder(
      builder: (context, setState) {
        controller.addListener(() {
          setState(() {
            currentPage = controller.page ?? 0;
          });
        });

        return SizedBox(
          height: 400 * variablePixelHeight,
          child: PageView.builder(
            controller: controller,
            itemCount: movies.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              double scale = 1.0;
              if (controller.position.haveDimensions) {
                scale = (1 - (currentPage - index).abs() * 0.2).clamp(0.8, 1.0);
              }

              return Transform.scale(
                scale: scale,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8 * variablePixelWidth),
                  child: MovieCard(movie: movies[index]),
                ),
              );
            },
          ),
        );
      },
    );
  }

}