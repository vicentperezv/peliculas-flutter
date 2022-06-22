
import 'package:flutter/material.dart';
import 'package:peliculas/models/models.dart';
import 'package:peliculas/providers/movies_provider.dart';
import 'package:provider/provider.dart';

class MovieSearchDelegate extends SearchDelegate{

  @override
  String get searchFieldLabel => 'Buscar película';


  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: ()=> query = '',)
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return  IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: (){
          close(context, null);
        },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return Text('');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    
    if( query.isEmpty ){
      return const _emptyContainer();
    }

    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);
    moviesProvider.getSuggestionsByQuery(query);
    
    return StreamBuilder(
      stream: moviesProvider.suggestionStream,
      builder: ( _ ,AsyncSnapshot<List<Movie>> snapshot){
        if(!snapshot.hasData) return const _emptyContainer();

        final movies = snapshot.data!;

        return ListView.builder(
          itemCount:  movies.length,
          itemBuilder: (_, int index) =>_MovieItem(movie: movies[index]),
        );

      },
      );
    
  }

}

class _emptyContainer extends StatelessWidget {
  const _emptyContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Center(
        child: Icon( Icons.movie_creation_outlined, color: Colors.black38, size: 130,)
      )
    );
  }
}

class _MovieItem extends StatelessWidget {

  final Movie movie;
  const _MovieItem({
    Key? key,
    required this.movie,
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    movie.heroId= 'search-${movie.id}';
    return ListTile(
      leading: Hero(
        tag: movie.heroId!,
        child: FadeInImage(
          placeholder: const AssetImage('assets/no-image.jpg'),
          image: NetworkImage(movie.fullPostingImg),
          width: 50,
          fit: BoxFit.contain,
        ),
      ),
      title: Text( movie.title ),
      subtitle: Text( movie.originalTitle),
      onTap: (){
        Navigator.pushNamed(context, 'details', arguments: movie);
      },
    );
  }
}