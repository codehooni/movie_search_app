import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_demo/models/movie.dart';
import 'package:movie_demo/services/api_service.dart';
import 'package:movie_demo/services/favorites_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movie_demo/widgets/my_movie_card.dart';

import '../main.dart';

class DetailScreen extends StatefulWidget {
  final Movie movie;

  const DetailScreen({super.key, required this.movie});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<bool> favoritesFuture;

  @override
  void initState() {
    super.initState();
    favoritesFuture = FavoritesService.isFavorite(widget.movie.id);
  }

  @override
  Widget build(BuildContext context) {
    bool isPosterPath = widget.movie.posterPath != null;
    final horizontalPadding = mq.width * 0.05;

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          if (isPosterPath) _buildBackGroundImage(),

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
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: mq.height * 0.15),

                    // My Movie Card
                    MyMovieCard(movie: widget.movie, isBig: true),

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
          ),

          // Back Button
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(top: 16.0, left: horizontalPadding),
              child: _buildBackButton(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackGroundImage() {
    return Image.network(
      '${APIService.baseImageUrl}/${widget.movie.posterPath}',
      width: mq.width,
      fit: BoxFit.cover,
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
          color: Theme.of(context).colorScheme.primaryContainer.withAlpha(70),
        ),
        child: Icon(CupertinoIcons.back),
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Row(
      children: [
        FutureBuilder(
          future: favoritesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildSmallButton(
                context,
                Icon(CupertinoIcons.heart, size: 22.0),
                () {},
              );
            }

            final bool isFavorite = snapshot.data ?? false;

            return _buildSmallButton(
              context,
              isFavorite
                  ? Icon(
                      CupertinoIcons.heart_fill,
                      size: 22.0,
                      color: Colors.red,
                    )
                  : Icon(CupertinoIcons.heart, size: 22),
              () => _onHeartTap(isFavorite),
            );
          },
        ),
        SizedBox(width: 8.0),
        _buildSmallButton(
          context,
          Icon(FontAwesomeIcons.download, size: 22.0),
          () {},
        ),
        SizedBox(width: 8.0),
        Expanded(child: _buildWatchButton(context)),
      ],
    );
  }

  Widget _buildSmallButton(
    BuildContext context,
    Icon icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.primaryContainer.withAlpha(180),
        ),
        child: icon,
      ),
    );
  }

  void _onHeartTap(bool isFavorite) async {
    if (isFavorite) {
      await FavoritesService.removeFavorite(widget.movie.id);
    } else {
      await FavoritesService.addFavorite(widget.movie);
    }

    setState(() {
      favoritesFuture = FavoritesService.isFavorite(widget.movie.id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isFavorite ? '즐겨찾기에서 제거되었습니다' : '즐겨찾기에 추가되었습니다'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  Widget _buildWatchButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        color: Theme.of(context).colorScheme.primary.withAlpha(180),
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
    bool isOverview = widget.movie.overview.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'OverView',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),

        SizedBox(height: 8.0),

        Text(
          isOverview ? widget.movie.overview : '줄거리 없음',
          style: TextStyle(fontSize: 15.0),
        ),
      ],
    );
  }
}
