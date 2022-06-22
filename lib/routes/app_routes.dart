
import 'package:flutter/material.dart';
import 'package:peliculas/models/models.dart';
import 'package:peliculas/screens/screen.dart';

class AppRoutes{

  static const initialRoute = 'home';

  static final menuOption = <MenuOption>[
    MenuOption(route: 'home', name:'Home Screen', screen: const HomeScreen(), icon: Icons.home),
    MenuOption(route: 'details', name:'Details Screen', screen: const DetailScreen(), icon: Icons.density_small_rounded),

  ];

  static Map<String,Widget Function(BuildContext)> getAppRoutes(){
    Map<String,Widget Function(BuildContext)> appRoutes ={};
    for(final option in menuOption){
      appRoutes.addAll({option.route: ( BuildContext context ) => option.screen });
    }
    return appRoutes;
  }

  static Route<dynamic> onGetAppRoutes( RouteSettings settings){
    return MaterialPageRoute(builder: (context) => const AlertScreen());
  } 
}