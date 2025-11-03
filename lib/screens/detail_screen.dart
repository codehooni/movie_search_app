import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_demo/models/movie.dart';
import 'package:movie_demo/widgets/my_big_movie_card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DetailScreen extends StatelessWidget {
  final Movie movie;

  const DetailScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Image.network(
            'https://image.tmdb.org/t/p/w500${movie.posterPath}',
            width: mq.width,
            fit: BoxFit.cover,
          ),

          // Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: AlignmentGeometry.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Theme.of(context).colorScheme.surface,
                    Theme.of(context).colorScheme.surface,
                  ],
                  //  0 ~  20% : 포스터
                  // 20 ~  40% : 그라데이션
                  // 40 ~ 100% : 배경
                  stops: [0.2, 0.4, 1.0],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back Button
                  _buildBackButton(context),

                  SizedBox(height: mq.height * 0.15),

                  // My Movie Card
                  MyBigMovieCard(movie: movie),

                  SizedBox(height: mq.height * 0.01),

                  // Buttons
                  _buildButtons(context),

                  SizedBox(height: mq.height * 0.04),

                  // Overview
                  _buildOverView(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.secondaryContainer.withAlpha(70),
        ),
        child: Icon(CupertinoIcons.back),
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Row(
      children: [
        _buildSmallButton(context, CupertinoIcons.heart),
        SizedBox(width: 8.0),
        _buildSmallButton(context, FontAwesomeIcons.download),
        SizedBox(width: 8.0),
        Expanded(child: _buildWatchButton(context)),
      ],
    );
  }

  Widget _buildSmallButton(BuildContext context, IconData iconData) {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.secondaryContainer.withAlpha(180),
      ),
      child: Icon(iconData, size: 22.0),
    );
  }

  Widget _buildWatchButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        color: Theme.of(context).colorScheme.primaryContainer.withAlpha(180),
      ),
      child: Center(
        child: Text(
          'Watch Now!',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
        ),
      ),
    );
  }

  Widget _buildOverView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'OverView',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),

        SizedBox(height: 8.0),

        Text(movie.overview, style: TextStyle(fontSize: 15.0)),
      ],
    );
  }
}
