import 'package:flutter/material.dart';
import 'package:peliculas/models/models.dart';
import 'package:peliculas/theme/app_theme.dart';
import 'package:peliculas/widgets/widgets.dart';

class DetailScreen extends StatelessWidget {
   
  const DetailScreen({Key? key}) : super(key: key);

  
  
  @override
  Widget build(BuildContext context) {

    final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;

    return  Scaffold(
      body:CustomScrollView(
        slivers: [
          _CustomAppBar( movie : movie),
          SliverList(
            delegate: SliverChildListDelegate([
              _PosterAndTitle( movie: movie),
              _Overview( movie: movie),              
              CastingCard( movieId: movie.id,)
              
              ]
            )
           )
        ],
      )
      );
    
  }
}

class _CustomAppBar extends StatelessWidget {
  final Movie movie;
  const _CustomAppBar({
    Key? key,
    required this.movie
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: AppTheme.primary,
      expandedHeight: 200,
      floating:false,
      pinned: true,
      flexibleSpace:  FlexibleSpaceBar(
        centerTitle: true,
        titlePadding:const EdgeInsets.all(0),
        title:Container(
          width: double.infinity,
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.only( bottom: 10, left: 10, right: 10),
          color: Colors.black12,
          child: Text(
            movie.title,
            style: TextStyle( fontSize: 16 ),
            ),
        ),
        background: FadeInImage(
          placeholder: const AssetImage('assets/loading.gif'), 
          image: NetworkImage(movie.fullBackdropPath),
          fit:BoxFit.cover,
          ),
          
      ),
    );
  }
}

class _PosterAndTitle extends StatelessWidget {

  final Movie movie;
  const _PosterAndTitle({
    Key? key,
    required this.movie
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only( top: 20 ),
      padding: const EdgeInsets.symmetric( horizontal: 20 ),
      child: Row(
        children: [
          Hero(
            tag: movie.heroId!,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder: const AssetImage('assets/loading.gif'), 
                image: NetworkImage( movie.fullPostingImg),
                height: 150,
                )
            ),
          ),
          SizedBox( width: 20, ),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: size.width  -190),
            child: Column( 
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                Text(movie.title, style: Theme.of(context).textTheme.headline5, overflow: TextOverflow.ellipsis, maxLines: 2,),
                Text(movie.originalTitle, style: Theme.of(context).textTheme.subtitle1, overflow: TextOverflow.ellipsis, maxLines: 2),
                Row(
                  children:[
                    const Icon( Icons.star_outline, size: 15, color: Colors.grey,),
                    const SizedBox( width:  5,),
                    Text(movie.voteAverage.toString(), style: Theme.of(context).textTheme.caption)
                  ]
                )
              ]),
          )
        ],)
    );
  }
}

class _Overview extends StatelessWidget {

  final Movie movie;
  const _Overview({
    Key? key,
    required this.movie
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return Container(
      padding: EdgeInsets.symmetric( horizontal: 30, vertical: 10),
      child: Text(
      movie.overview  ,
        textAlign: TextAlign.justify,
        style: Theme.of(context).textTheme.subtitle1
      ),

    );
  }
}