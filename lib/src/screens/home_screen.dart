import 'package:flutter/material.dart';
import 'package:peliculas/src/providers/movies_provider.dart';
import 'package:peliculas/src/widgets/widgets.dart';
import 'package:provider/provider.dart';

import 'package:peliculas/src/search/search_delegate.dart';

class HomeScreen extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {

    final moviesProviders = Provider.of<MoviesProvider>(context);

    //print(moviesProviders.obDisplayMovies);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Peliculas en cines'),
        elevation: 0,
        actions: [
          IconButton(
            /* 
              Un delegate es una clase o widget que requiere ciertas condiciones
            */
            onPressed: () => showSearch(context: context, delegate: MoviesSearchDelegate()) , 
            icon: Icon(Icons.search_outlined)
          )
        ],
      ),
      /* 
        SingleChildScrollView nos permite agregar mas elementos en la vista
        y poder hacerles scroll
      */
      body: SingleChildScrollView(
        child: Column(
          children: [
            //Tarjeta principal
            CardSwiper(movies: moviesProviders.obDisplayMovies),

            //Slider de peliculas
            MovieSlider(
              movies: moviesProviders.popularMovies,
              title: 'Más Vistas',
              onNextPage: () => moviesProviders.getPopularMovies(),
            ),
           

            //Listado horizontal de peliculas
          ],
        ),
      )
    );
  }
}