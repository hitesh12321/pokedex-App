import 'package:bloc/bloc.dart';
import 'package:pokedex/bloc/pokemon_event_n_state.dart';

import 'package:pokedex/data/pokemon_reposetory.dart';

class PokemonBloc extends Bloc<PokemonEvent, PokemonState> {
  PokemonBloc() : super(PokemonInitial()) {
    try {
      on((event, emit) async {
        if (event is PokemonPageRequest) {
          emit(PokemonLoadInProgress());

          final pokemonpageresponse = await PokemonReposetory()
              .getPokemonHomePage(event.page);

          emit(
            PokemonLoadSuccess(
              canLoadNExtPage: pokemonpageresponse.canLoadNextPage,
              pokemonListing: pokemonpageresponse.PokemonListings,
            ),
          );
        }
      });
    } catch (e) {
      emit(PokemonLoadFailed(error: e as Error));
    }
  }
}
