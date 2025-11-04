import 'package:flutter/material.dart';
import 'package:movie_demo/models/movie.dart';
import 'package:movie_demo/screens/detail_screen.dart';

class MyBigMovieCard extends StatelessWidget {
  final Movie movie;

  const MyBigMovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          // Image
          _buildImage(context),

          SizedBox(width: 16.0),

          // Information
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Type
                _buildType(context),

                // Title
                _buildTitle(context),

                // year - genre - time
                Row(
                  children: [
                    _buildDetailText(context, movie.year),

                    _buildDivider(context),

                    _buildDetailText(context, movie.genreNames[0]),

                    _buildDivider(context),

                    _buildDetailText(
                      context,
                      '★ ${movie.voteAverage.toStringAsFixed(1)}',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    return Hero(
      tag: 'hero-movie-${movie.id}',
      child: ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(12.0),
        child: movie.posterPath != null
            ? Image.network(
                'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                width: 105,
                height: 150,
                fit: BoxFit.cover,
              )
            : Container(
                width: 105,
                height: 150,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                ),
                child: Icon(
                  Icons.image_not_supported_outlined,
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
              ),
      ),
    );
  }

  Widget _buildType(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        margin: EdgeInsets.only(bottom: 18.0),
        decoration: BoxDecoration(
          color: Theme.of(
            context,
          ).colorScheme.secondaryContainer.withAlpha(180),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Text(
          'Movie',
          style: TextStyle(fontSize: 11.0, color: Colors.grey.shade200),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        movie.title,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: 26.0,
        ),
      ),
    );
  }

  Widget _buildDetailText(BuildContext context, String text) {
    return Text(
      text,
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSecondaryContainer,
        fontWeight: FontWeight.w400,
        fontSize: 15.0,
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      width: 5,
      height: 5,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSecondaryContainer,
        shape: BoxShape.circle,
      ),
    );
  }
}
