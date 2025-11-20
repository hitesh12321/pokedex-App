import 'package:flutter/material.dart';
import 'package:pokedex/onboard/onboard.dart';
import 'package:pokedex/pokedex_view.dart';
import 'package:pokedex/bloc/pokemon_bloc.dart';
import 'package:pokedex/bloc/pokemon_event_n_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
   


    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => PokemonBloc()..add(PokemonPageRequest(page: 0)),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: Theme.of(context).copyWith(
          primaryColor: Colors.red,
    
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        ),
        home: const PokedexOnboardPage(),
      ),
    );
  }
}