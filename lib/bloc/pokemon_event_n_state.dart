import 'package:pokedex/data/pokemon_page_response.dart';

//Events
abstract class PokemonEvent {}

class PokemonPageRequest extends PokemonEvent {
  final int page;

  PokemonPageRequest({required this.page});
}

// States
abstract class PokemonState {}

class PokemonInitial extends PokemonState {}

class PokemonLoadInProgress extends PokemonState {}

class PokemonLoadSuccess extends PokemonState {
  final List<PokemonListing> pokemonListing;
  final bool canLoadNExtPage;

  PokemonLoadSuccess({
    required this.canLoadNExtPage,
    required this.pokemonListing,
  });
}

class PokemonLoadFailed extends PokemonState {
  final Error error;

  PokemonLoadFailed({required this.error});
}
