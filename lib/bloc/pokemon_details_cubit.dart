import 'package:pokedex/bloc/pokemon_details_state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/data/pokemon_page_response.dart';
import 'package:pokedex/data/pokemon_reposetory.dart';

class NavCubit extends Cubit<NavState> {
  final PokemonListing pokemonListing;

  NavCubit({required this.pokemonListing}) : super(InitialSelection());

  void showPokemonDetails() async {
    try {
      emit(LoadingSelectedPokemon());
      final p = pokemonListing.id;
      final selectedPokemoninfo = await PokemonReposetory().getPokemonInfoBP(p);
      final selectedPokemonspecies = await PokemonReposetory()
          .getPokemonAboutBP(p);
      emit(
        SelectedPokemonLoadDone(
          info: selectedPokemoninfo,
          species: selectedPokemonspecies,
        ),
      );
    } catch (e) {
      emit(SelectedPokemonLoadFailed(error: e as Error));
    }
  }

  void popToPokedex() {
    emit(BackToPokedex());
  }
}
