// ignore_for_file: prefer_final_fields

/* 
  Aqui iran las llamadas a la API para generar un estado a usar en la app.
  Para que MoviesProvider sea un provider oficial (por su estructura), es necesario
  extender la clase de un ChangeNotifier
*/


import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:peliculas/src/helpers/debouncer.dart';
import 'package:peliculas/src/models/models.dart';

class MoviesProvider extends ChangeNotifier{

  String _baseURL = 'api.themoviedb.org';
  String _apiKey = '18f8892de874ff07d7c91a2b179ab025';
  String _language = 'es-ES';

  List<Movie> obDisplayMovies = [];
  List<Movie> popularMovies = [];
  int _popularPage = 0;

  final debouncer = Debouncer(
    duration: Duration(milliseconds: 500),
  );

  final StreamController<List<Movie>> _suggestionStreamController = new StreamController.broadcast();

  Stream<List<Movie>> get suggestionStream => _suggestionStreamController.stream;

  /* 
    PARA TRABAJAR CON EL CREDITS PROVIDER!
    Usaremos un map que recibira por argumentos:
    int - ID de la pelicula
    List - Listado del cast
  */
  Map<int, List<Cast>> moviesCast = {};

  MoviesProvider() {
    getOnDisplayMovies();
    getPopularMovies();
  }

  Future<String> _getJsonData(String endpoint, [int page = 1]) async {
    final url = Uri.https( _baseURL , endpoint, {
          'api_key' : _apiKey,
          'language': _language,
          'page': '$page'
        });
    
    final response = await http.get(url);
    return response.body;
  }


  getOnDisplayMovies() async {
    //print('getOnDisplayMovies');

    //INICIANDO CON LA PETICION HTTP
   /*  var url = Uri.https( _baseURL , '3/movie/now_playing', {
      'api_key' : _apiKey,
      'language': _language,
      'page': '1'
    });
    // Await the http get response, then decode the json-formatted response.
    final response = await http.get(url); */

    final jsonData = await _getJsonData('3/movie/now_playing');
    
    final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);
    
   /*  //Para convertir en un Map los datos del response hacemos lo siguiente
    final Map<String, dynamic> decodeData = json.decode(response.body); */

    //print(nowPlayingResponse.results[1].title);

    obDisplayMovies = nowPlayingResponse.results;
    notifyListeners();   
  }


  getPopularMovies() async{

    _popularPage++;

    final jsonData = await _getJsonData('3/movie/popular', _popularPage);
    final popularResponse = PopularResponse.fromJson(jsonData);

    popularMovies = [ ...popularMovies,  ...popularResponse.results ];
    notifyListeners();   
  }

  Future<List<Cast>> getCastingMovie(int movieId) async {

    /* 
      para evitar que vuelva a ejecutar la peticion si el id es el mismo, 
      hacemos lo siguiente
    */
    
    if( moviesCast.containsKey(movieId)) return moviesCast[movieId]!;


    //TODO: Revisar el mapa
    print('pidiendo info al servidor de los actores');
    final jsonData = await _getJsonData('3/movie/$movieId/credits');
    final creditsResponse = CreditsResponse.fromJson(jsonData);

    //Al macenamos el resultado en el mapa
    moviesCast[movieId] = creditsResponse.cast;
    return creditsResponse.cast;
  }

  Future<List<Movie>> searchMovies(String query) async {
    final url = Uri.https( _baseURL , '3/search/movie', {
      'api_key' : _apiKey,
      'language': _language,
      'query' : query
    });

    final response = await http.get(url);
    final searchResponse = SearchResponse.fromJson(response.body);

    return searchResponse.results;

  }

  //CREAMOS UNA FUNCION PARA SETEAR EL VALOR DLE QUERY 
  void getSuggestionByQuery(String searchTerm) {
    debouncer.value = '';
    debouncer.onValue = ( value ) async {
      //print('tenemos valor a buscar: $value');

      final results = await searchMovies(value);
      _suggestionStreamController.add(results);
    };

    final timer = Timer.periodic(Duration(milliseconds: 300), (_) { 
      debouncer.value = searchTerm;
    });

    Future.delayed(Duration(milliseconds: 301)).then((_) => timer.cancel());

  }
}