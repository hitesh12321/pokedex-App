import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/bloc/pokemon_details_cubit.dart';
import 'package:pokedex/bloc/pokemon_bloc.dart';
import 'package:pokedex/bloc/pokemon_event_n_state.dart';
import 'package:pokedex/selected_pokemon_view.dart';

// in pokedex view we passing a stateful widget
class PokedexView extends StatefulWidget {
  const PokedexView({super.key});

  @override
  State<PokedexView> createState() => _PokedexViewState();
}

class _PokedexViewState extends State<PokedexView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 234, 71, 59),
        title: Text(
          "POKEDEX",
          style: TextStyle(
            fontSize: 40,
            backgroundColor: const Color.fromARGB(255, 237, 216, 151),
          ),
        ),
        centerTitle: true,
      ),

      body: BlocBuilder<PokemonBloc, PokemonState>(
        builder: (context, state) {
          if (state is PokemonLoadInProgress) {
            return Center(child: CircularProgressIndicator());
          } else if (state is PokemonLoadSuccess) {
            return GridView.builder(
              itemCount: state.pokemonListing.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                final listing = state.pokemonListing[index];
                final String imageUrl =
                    'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${state.pokemonListing[index].id}.png';
                return Card(
                  elevation: 27,
                  child: GridTile(
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) {
                            final navCubit = NavCubit(pokemonListing: listing);
                            navCubit
                                .showPokemonDetails(); // 👈 trigger the fetch immediately
                            return BlocProvider(
                              create: (_) => navCubit,
                              child: const SelectedPokemonView(),
                            );
                          },
                        ),                                               
                      ),

                      child: Column(
                        children: [
                          SizedBox(
                            height: 105,
                            width: 105,
                            child: Image.network(imageUrl),
                          ),
                          Text(state.pokemonListing[index].name),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (state is PokemonLoadFailed) {
            return Center(
              child: Text("the error is  ${state.error.toString()}"),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
