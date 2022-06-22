import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas/helpers/debouncer.dart';
import 'package:peliculas/models/models.dart';
import 'package:peliculas/models/search_movie_response.dart';

class MoviesProvider extends ChangeNotifier{

  String _apiKey = 'f2d2c1803886adc174729d62f7bb2a8e';
  String _baseUrl = 'api.themoviedb.org';
  String _language = 'es-ES';

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];
  Map<int, List<Cast>>  movieCast= {};
  int _popularPage =0;

  final debouncer = Debouncer(
    duration: Duration(milliseconds: 500),
     );

  final StreamController<List<Movie>> _suggestionStreamController = new StreamController.broadcast();
  Stream<List<Movie>> get suggestionStream => this._suggestionStreamController.stream;


  MoviesProvider(){
    print('MoviesProvider');

    getOnDisplayMovies();
    getPopularMovies();
    
  }

  Future<String> _getJsonData( String endpoint, [int page = 1]) async {
    
    var url =Uri.https(_baseUrl, endpoint, {
      'api_key' : _apiKey,
      'language' : _language,
      'page' : '$page',
      });

    // Await the http get response, then decode the json-formatted response.
    final response = await http.get(url);
    return response.body;
  }

  getOnDisplayMovies() async {

    final jsonData = await _getJsonData('3/movie/now_playing');
    
    final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);    
    onDisplayMovies = nowPlayingResponse.results;

    notifyListeners();
  }

  getPopularMovies() async {
    _popularPage++;
    final jsonData = await _getJsonData('3/movie/popular', _popularPage);
    
    final popularResponse = PopularResponse.fromJson(jsonData) ;    
    popularMovies = [...popularMovies, ...popularResponse.results];

    notifyListeners();

  }
  Future<List<Cast>> getMovieCast(int movieId) async {
    
    if( movieCast.containsKey(movieId)) return movieCast[movieId]!;    
    final jsonData = await _getJsonData('3/movie/$movieId/credits', _popularPage);
    final creditsResponse = CreditsResponse.fromJson(jsonData);
    movieCast[movieId] = creditsResponse.cast;
    return creditsResponse.cast;
  }

  Future<List<Movie>> searchMovie( String query ) async {
    var url =Uri.https(_baseUrl, '3/search/movie/', {
      'api_key' : _apiKey,
      'language' : _language,
      'query': query,
      });

    // Await the http get response, then decode the json-formatted response.
    final response = await http.get(url);
    final searchMovieResponse =SearchMovieResponse.fromJson(response.body);
    return searchMovieResponse.results;
  }

  void getSuggestionsByQuery( String searchTerm ){
    debouncer.value = '';

    debouncer.onValue = ( value ) async {
        final results = await this.searchMovie( value );
        this._suggestionStreamController.add(results);
    };

    final timer = Timer.periodic(Duration(milliseconds: 300), (_) { 
      debouncer.value = searchTerm;
    });

    Future.delayed(Duration(milliseconds: 301)).then((_) => timer.cancel());
  }
}