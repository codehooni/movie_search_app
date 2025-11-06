import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_demo/models/movie.dart';
import 'package:movie_demo/screens/detail_screen.dart';
import 'package:movie_demo/services/api_service.dart';

import '../main.dart';

class MyMovieCard extends StatelessWidget {
  final Movie movie;
  final bool isBig;
  final bool isHome;

  const MyMovieCard({
    super.key,
    required this.movie,
    this.isBig = false,
    this.isHome = false,
  });

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
            if (!isHome)
              // Image
              _buildImage(context),

            if (!isHome) SizedBox(width: 16.0),

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

            if (isHome) _buildPlayButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    final width = isBig ? mq.width * 0.27 : mq.width * 0.17;
    final height = width / 0.7;

    return Hero(
      tag: 'hero-movie-${movie.id}',
      child: ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(mq.width * 0.03),
        child: movie.posterPath != null
            ? Image.network(
                '${APIService.baseImageUrl}/${movie.posterPath}',
                width: width,
                height: height,
                fit: BoxFit.cover,
              )
            : _buildImageHolder(context),
      ),
    );
  }

  Widget _buildImageHolder(BuildContext context) {
    final width = isBig ? mq.width * 0.25 : mq.width * 0.17;
    final height = width / 0.7;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: Icon(
        Icons.image_not_supported_outlined,
        color: Theme.of(context).colorScheme.onPrimaryContainer.withAlpha(160),
        size: width * 0.4,
      ),
    );
  }

  Widget _buildType(BuildContext context) {
    final horizontalPadding = isBig ? mq.width * 0.02 : mq.width * 0.015;
    final verticalPadding = isBig ? mq.height * 0.005 : mq.height * 0.003;
    final marginBottom = isBig ? mq.height * 0.02 : mq.height * 0.01;
    final borderRadius = isBig ? mq.width * 0.03 : mq.width * 0.02;
    final fontSize = isBig ? mq.width * 0.03 : mq.width * 0.025;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding,
          horizontal: horizontalPadding,
        ),
        margin: EdgeInsets.only(bottom: marginBottom),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Text(
          'Movie',
          style: TextStyle(
            fontSize: fontSize,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    final fontSize = isBig ? mq.width * 0.06 : mq.width * 0.045;
    final maxLines = isBig ? 2 : 1;
    final bottomPadding = isBig ? mq.height * 0.01 : 0.0;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Text(
        movie.title,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
        ),
      ),
    );
  }

  Widget _buildDetailText(BuildContext context, String text) {
    final fontSize = isBig ? mq.width * 0.035 : mq.width * 0.03;

    return Text(
      text,
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurface.withAlpha(160),
        fontWeight: FontWeight.w400,
        fontSize: fontSize,
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    final size = isBig ? mq.width * 0.012 : mq.width * 0.01;
    final margin = isBig ? mq.width * 0.01 : mq.width * 0.008;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: margin),
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface.withAlpha(160),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildPlayButton(BuildContext context) {
    return Container(
      padding: EdgeInsetsGeometry.all(mq.width * 0.02),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.primaryContainer.withAlpha(40),
      ),
      child: Icon(Icons.play_arrow, size: mq.width * 0.09),
    );
  }
}
