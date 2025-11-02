// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Movie _$MovieFromJson(Map<String, dynamic> json) => Movie(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  posterPath: json['poster_path'] as String?,
  genreIds: (json['genre_ids'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  voteAverage: (json['vote_average'] as num).toDouble(),
  overview: json['overview'] as String,
  releaseDate: json['release_date'] as String,
  originalLanguage: json['original_language'] as String,
  backdropPath: json['backdrop_path'] as String?,
  adult: json['adult'] as bool?,
  popularity: (json['popularity'] as num?)?.toDouble(),
);

Map<String, dynamic> _$MovieToJson(Movie instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'poster_path': instance.posterPath,
  'genre_ids': instance.genreIds,
  'vote_average': instance.voteAverage,
  'overview': instance.overview,
  'release_date': instance.releaseDate,
  'original_language': instance.originalLanguage,
  'backdrop_path': instance.backdropPath,
  'adult': instance.adult,
  'popularity': instance.popularity,
};
