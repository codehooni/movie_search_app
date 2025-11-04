import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_demo/models/movie.dart';
import 'package:movie_demo/screens/detail_screen.dart';

class MyMovieCard extends StatelessWidget {
  final Movie movie;

  const MyMovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailScreen(movie: movie)),
        );
      },
      child: Container(
        color: Colors.transparent,
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

                      _buildDetailText(context, movie.genreNames.first),

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
                width: 70,
                height: 100,
                fit: BoxFit.cover,
              )
            : Container(
                width: 70,
                height: 100,
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
        padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 6.0),
        margin: EdgeInsets.only(bottom: 8.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          'Movie',
          style: TextStyle(fontSize: 11.0, color: Colors.grey.shade200),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      movie.title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.bold,
        fontSize: 18.0,
      ),
    );
  }

  Widget _buildDetailText(BuildContext context, String text) {
    return Text(
      text ?? '',
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSecondaryContainer,
        fontWeight: FontWeight.w400,
        fontSize: 14.0,
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      width: 4,
      height: 4,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSecondaryContainer,
        shape: BoxShape.circle,
      ),
    );
  }
}
