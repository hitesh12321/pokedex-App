import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/bloc/pokemon_details_cubit.dart';
import 'package:pokedex/bloc/pokemon_details_state.dart';

class SelectedPokemonView extends StatelessWidget {
  const SelectedPokemonView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<NavCubit, NavState>(
      listener: (context, state) {
        if (state is BackToPokedex) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Pokemon '),
          backgroundColor: Colors.redAccent,
          leading: IconButton(
            onPressed: () {
              context.read<NavCubit>().popToPokedex();
            },
            icon: Icon(Icons.arrow_back),
          ),
        ),
        body: BlocBuilder<NavCubit, NavState>(
          builder: (context, state) {
            if (state is LoadingSelectedPokemon) {
              return Center(child: CircularProgressIndicator());
            } else if (state is SelectedPokemonLoadDone) {
              final info = state.info;
              final species = state.species;
              String type = info.types.isNotEmpty
                  ? info.types.join(", ")
                  : "Unknown";
              final String imageUrl =
                  'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${info.id}.png';

              return Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,

                  children: [
                    Row(
                      children: [
                        Column(
                          children: [
                            Text(
                              info.name,
                              style: const TextStyle(
                                fontSize: 29,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              species.description,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 21, 10, 10),
                              ),
                            ),
                          ],
                        ),
                        // Container(height: 200, width: 1, color: Colors.black),
                        SizedBox(
                          height: 220,
                          width: 220,
                          child: Image.network(imageUrl),
                        ),
                      ],
                    ),

                    Container(
                      height: 30,
                      width: 600,
                      color: const Color.fromARGB(255, 233, 128, 120),
                      child: Center(
                        child: Text(
                          "About",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 39),
                    Row(
                      children: [
                        Column(
                          children: [
                            Text("Weight : ${info.weight}"),
                            Text("Height : ${info.height}"),
                          ],
                        ),
                        SizedBox(width: 100),
                        Column(
                          children: [
                            Text("Type : $type"),
                            Text(" Growth-Rate :${species.growthRate}"),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            } else if (state is SelectedPokemonLoadFailed) {
              return Center(
                child: Text('the erroe is ${state.error.toString()}'),
              );
            } else {
              return const Center(
                child: Text("No Pokémon selected or failed to load"),
              );
            }
          },
        ),
      ),
    );
  }
}
