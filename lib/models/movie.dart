import 'package:json_annotation/json_annotation.dart';

part 'movie.g.dart';

@JsonSerializable()
class Movie {
  final int id;
  final String title;
  @JsonKey(name: 'poster_path')
  final String? posterPath;
  @JsonKey(name: 'genre_ids')
  final List<int> genreIds;
  @JsonKey(name: 'vote_average')
  final double voteAverage;
  final String overview;
  @JsonKey(name: 'release_date')
  final String releaseDate;
  @JsonKey(name: 'original_language')
  final String originalLanguage;
  @JsonKey(name: 'backdrop_path')
  final String? backdropPath;
  final bool? adult;
  final double? popularity;

  Movie({
    required this.id,
    required this.title,
    this.posterPath,
    required this.genreIds,
    required this.voteAverage,
    required this.overview,
    required this.releaseDate,
    required this.originalLanguage,
    this.backdropPath,
    this.adult,
    this.popularity,
  });

  // 개봉년도 추출
  String get year => releaseDate.split('-').first;

  // 장르명 변환
  List<String> get genreNames {
    const genreMap = {
      12: '모험',
      14: '판타지',
      16: '애니메이션',
      18: '드라마',
      27: '호러',
      28: '액션',
      35: '코미디',
      53: '스릴러',
      80: '범죄',
      878: 'SF',
      10402: '뮤직',
      10749: '로맨스',
      10752: '전쟁',
    };
    return genreIds.map((id) => genreMap[id] ?? '알수없음').toList();
  }

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);

  Map<String, dynamic> toJson() => _$MovieToJson(this);
}
