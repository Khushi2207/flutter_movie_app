import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'movie_model.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class MovieModel {
  @HiveField(0) final int id;
  @HiveField(1) final String title;
  @HiveField(2) @JsonKey(name: 'poster_path') final String posterPath;
  @HiveField(3) @JsonKey(name: 'backdrop_path') final String backdropPath;
  @HiveField(4) final String overview;
  @HiveField(5) @JsonKey(name: 'release_date') final String releaseDate;
  @HiveField(6) @JsonKey(name: 'vote_average') final double voteAverage;
  @HiveField(7) @JsonKey(name: 'vote_count') final int voteCount;
  @HiveField(8) @JsonKey(name: 'genre_ids') final List<int> genreIds;

  MovieModel({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.backdropPath,
    required this.overview,
    required this.releaseDate,
    required this.voteAverage,
    required this.voteCount,
    required this.genreIds,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) => _$MovieModelFromJson(json);

  Map<String, dynamic> toJson() => _$MovieModelToJson(this);
}