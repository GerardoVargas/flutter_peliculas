// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:peliculas/src/models/models.dart';
import 'package:peliculas/src/widgets/casting_cards.dart';

class DetailsScreen extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {

    //TODO: 
    final Movie movie = ModalRoute.of(context)?.settings.arguments as Movie;
    print(movie.title);

    return Scaffold(
      body: CustomScrollView(
        /* 
          Los sliver son widgets que tienen comportamiento preprogramado cuando se
          hace scroll en el padre. Se setea de la siguiente manera: 
          slivers: []

          Pero si deseamos utilizar algun Widget que no sea soportado por el slives
          se recomienda usar un SliverList dentro del sliver
        */
        slivers: [
          _CustomAppBar(movie),
          SliverList(delegate: SliverChildListDelegate([
              _PosterAndTitle(movie),
              _Overview(movie),
              CastingCards( movie.id )
             
            ])
          )
        ],
      )
    );
  }
}

class _CustomAppBar extends StatelessWidget {

  final Movie movie;

  const _CustomAppBar( this.movie );

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.indigo,
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: EdgeInsets.all(0),
        title: Container(
          width: double.infinity,
          color: Colors.black38,
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
          child: Text(
            movie.title,
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
        background: FadeInImage(
          placeholder: AssetImage('assets/loading.gif'), 
          image: NetworkImage(movie.fullBackdropPath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _PosterAndTitle extends StatelessWidget {
  final Movie movie;

  const _PosterAndTitle(this.movie);

  @override
  Widget build(BuildContext context) {

  final TextTheme textTheme = Theme.of(context).textTheme;
  final size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Hero(
            tag: movie.heroId!,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder: AssetImage('assets/no-image.jpg'), 
                image: NetworkImage(movie.fullPosterImg),
                height: 150,
              ),
            ),
          ),

          SizedBox(width: 20),

          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: size.width - 190),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title, 
                  style: textTheme.headline5,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2
                ),
                Text(
                  movie.originalTitle, 
                  style: textTheme.subtitle1,
                  maxLines: 2
                ),
                Row(
                  children: [
                    Icon(Icons.star_outline, size: 24, color: Colors.grey),
                    SizedBox(width: 10),
                    Text('${movie.voteAverage}')
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _Overview extends StatelessWidget {

  final Movie movie;

  const _Overview(this.movie);

  @override
  Widget build(BuildContext context) {

  final TextTheme textTheme = Theme.of(context).textTheme;
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Text(
        movie.overview,
        textAlign: TextAlign.justify,
        style: textTheme.subtitle1
      ),
    );
  }
}