class PokemonDetails {
  final String name;
  final int id;
  final String description;
  final List<String> types;
  final int weight;
  final int height;

  PokemonDetails({
    required this.description,
    required this.height,
    required this.id,
    required this.name,
    required this.types,
    required this.weight,
  });
}
