import 'package:flutter/material.dart';
import 'package:peliculas/src/models/models.dart';
import 'package:peliculas/src/providers/movies_provider.dart';
import 'package:provider/provider.dart';

class MoviesSearchDelegate extends SearchDelegate {

  @override
  String get searchFieldLabel => 'Buscar Pelicula';

  @override
  List<Widget>? buildActions(BuildContext context) {
    // Icono de la derecha que hara alguna accion
    return [
      IconButton(
        onPressed: () => query = '', 
        icon: Icon(Icons.clear)
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // icono del lado izquierdo, podemos usarlo para regresar a la vista anterior
    return IconButton(
      // usamos el metodo close, recibe el contexto y retornamos un null para no hacer nada
      onPressed: () { 
        close(context, null);
      }, 
      icon: Icon(Icons.arrow_back)
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
     return Text('buildResults');
  }


  Widget _emptyContainer() {
    return Container(
      child: Center(
        child: Icon(Icons.movie_creation_outlined, color: Colors.black38, size: 150),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    if( query.isEmpty) {
      return _emptyContainer();
    }

    print('http request');
    
    //CUANDO NECESITAMOS PETICIONES HTTP, SIEMPRE USAMOS UN FUTURE BUILDER
    //NOTA: UN FUTURE BUILDER NO SE PUEDE CANCELAR, 
    //ASI QUE CONVERTIMOS A UN STREAMBUILDER

    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);
    moviesProvider.getSuggestionByQuery(query);

    return StreamBuilder(
      stream: moviesProvider.suggestionStream,
      builder: ( _ , AsyncSnapshot<List<Movie>> snapshot) {
        if( !snapshot.hasData) return _emptyContainer();

        final movies = snapshot.data!;

        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (_, index) => _MovieItem(movies[index]),
        );
      },
    );
  }
  
}

//CREAMOS UN WIDGET PARA MOSTRAR LOS ELEMENTOS DE LA BUSQUEDA
class _MovieItem extends StatelessWidget {
  
  final Movie movie;

  const _MovieItem(this.movie);

  @override
  Widget build(BuildContext context) {

    movie.heroId = 'search-${movie.id}';

    return ListTile(
      leading: Hero(
        tag: movie.heroId!,
        child: FadeInImage(
          placeholder: AssetImage('assets/no-image.jpg'), 
          image: NetworkImage(movie.fullPosterImg),
          width: 50,
          fit: BoxFit.contain,
        ),
      ),
      title: Text(movie.title),
      subtitle: Text(movie.originalTitle),
      onTap: () {
        Navigator.pushNamed(context, 'details', arguments: movie);
      },
    );
  }
}