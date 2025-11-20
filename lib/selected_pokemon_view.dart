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
        backgroundColor: const Color(0xFFEA473B),
        body: BlocBuilder<NavCubit, NavState>(
          builder: (context, state) {
            if (state is LoadingSelectedPokemon) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            } else if (state is SelectedPokemonLoadDone) {
              return _PokemonDetailContent(
                info: state.info,
                species: state.species,
              );
            } else if (state is SelectedPokemonLoadFailed) {
              return Center(child: Text('Error: ${state.error}'));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

// Converted to StatefulWidget to handle Animation
class _PokemonDetailContent extends StatefulWidget {
  final dynamic info;
  final dynamic species;

  const _PokemonDetailContent({required this.info, required this.species});

  @override
  State<_PokemonDetailContent> createState() => _PokemonDetailContentState();
}

class _PokemonDetailContentState extends State<_PokemonDetailContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true); // Go up, then down, repeat.

    _animation = Tween<double>(
      begin: 0,
      end: 10,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String imageUrl =
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${widget.info.id}.png';

    return Column(
      children: [
        SafeArea(
          bottom: false,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.40,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () =>
                            context.read<NavCubit>().popToPokedex(),
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        "Pokedex Entry",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const Spacer(flex: 2),
                    ],
                  ),
                ),

                const Spacer(),

                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _animation.value),
                      child: child,
                    );
                  },
                  child: Hero(
                    tag: widget.info.id,
                    child: Image.network(
                      imageUrl,
                      height: 220,
                      width: 220,
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const SizedBox(
                          height: 220,
                          width: 220,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.white54,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),

        // BOTTOM
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: ListView(
              padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
              children: [
                //NAME
                Text(
                  widget.info.name.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 12),

                // TYPES
                Center(
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 5,
                    alignment: WrapAlignment.center,
                    children: (widget.info.types as List)
                        .map((t) => _TypeChip(typeName: t))
                        .toList(),
                  ),
                ),

                const SizedBox(height: 30),

                // STATS ROW
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _StatColumn(
                      label: "Weight",
                      value: "${widget.info.weight / 10} KG",
                    ),
                    Container(width: 1, height: 40, color: Colors.grey[300]),
                    _StatColumn(
                      label: "Height",
                      value: "${widget.info.height / 10} M",
                    ),
                    Container(width: 1, height: 40, color: Colors.grey[300]),
                    _StatColumn(
                      label: "Growth",
                      value: widget.species.growthRate,
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                //  DESCRIPTON
                const Text(
                  "Pokedex Entry",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.species.description.replaceAll('\n', ' '),
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

//helper widgt

class _TypeChip extends StatelessWidget {
  final String typeName;
  const _TypeChip({required this.typeName});

  @override
  Widget build(BuildContext context) {
    // Assign colors based on type (You can expand this map)
    Color color;
    switch (typeName.toLowerCase()) {
      case 'grass':
        color = Colors.green;
        break;
      case 'fire':
        color = Colors.orange;
        break;
      case 'water':
        color = Colors.blue;
        break;
      case 'electric':
        color = Colors.amber;
        break;
      case 'poison':
        color = Colors.purple;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        typeName.toUpperCase(),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
          color: color.withOpacity(1.0),
        ),
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final String value;

  const _StatColumn({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
      ],
    );
  }
}
