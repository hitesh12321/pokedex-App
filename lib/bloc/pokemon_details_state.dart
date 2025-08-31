import 'package:pokedex/data/selected_pokemon_response.dart';

abstract class NavState {} //states

//1
class InitialSelection extends NavState {}

//2
class LoadingSelectedPokemon extends NavState {}

//3
class SelectedPokemonLoadDone extends NavState {
  final SelectedPokemonResponseInfo info;
  final SelectedPokemonSpeciesResponse species;
  SelectedPokemonLoadDone({required this.info, required this.species});
}

//4
class SelectedPokemonLoadFailed extends NavState {
  final Error error;
  SelectedPokemonLoadFailed({required this.error});
}

//5
class BackToPokedex extends NavState {}
