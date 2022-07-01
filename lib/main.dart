import 'package:flutter/material.dart';
import 'package:peliculas/src/screens/screens.dart';
import 'package:provider/provider.dart';
import 'package:peliculas/src/providers/movies_provider.dart';
void main() => runApp(AppState());

class AppState extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        /* 
          Cuando se carga la app por defecto el provider espera a ser inicializado
          ya que tiene una propiedad lazy que esta en true.
          Para que se ejecute inmediatamente, hay que cambiar a false
        */
        ChangeNotifierProvider(create: (_) => MoviesProvider(), lazy: false)
      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     debugShowCheckedModeBanner: false,
      title: 'Peliculas App',
      initialRoute: 'home',
      routes: {
        'home': ( _ ) => HomeScreen(),
        'details': ( _ ) => DetailsScreen(),
      },
      theme: ThemeData.light().copyWith(
        appBarTheme: const AppBarTheme(
          color: Colors.indigo
        )
      ),
    );
  }
}