import 'package:flutter/material.dart';
import 'package:peliculas/providers/movies_provider.dart';
import 'package:peliculas/search/search_delegate.dart';

import 'package:peliculas/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
   
  const HomeScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    final moviesProvider = Provider.of<MoviesProvider>(context);

    return  Scaffold(
      appBar: AppBar(
        title: const Text('Películas en cine'),
        actions: [
          IconButton(
            icon:const Icon( Icons.search),
            onPressed: ()=> showSearch(context: context, delegate: MovieSearchDelegate()),)
        ],        
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox( height:25 ),
            CardSwiper( movies: moviesProvider.onDisplayMovies ),
            const SizedBox( height:25 ),      
            MovieSlider( 
              movies: moviesProvider.popularMovies , 
              title: 'Populares',
              onNextPage: () => moviesProvider.getPopularMovies(),)
      
          ]
             
          ),
      ),
      );
    
  }
}