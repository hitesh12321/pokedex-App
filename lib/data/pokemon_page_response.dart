// {
//   "count": 1302,
//   "next": "https://pokeapi.co/api/v2/pokemon?offset=300&limit=100",
//   "previous": "https://pokeapi.co/api/v2/pokemon?offset=100&limit=100",
//   "results": [
//     {
//       "name": "unown",
//       "url": "https://pokeapi.co/api/v2/pokemon/201/"
//     },
//     {
//       "name": "wobbuffet",
//       "url": "https://pokeapi.co/api/v2/pokemon/202/"
//     },
//     {
//       "name": "girafarig",
//       "url": "https://pokeapi.co/api/v2/pokemon/203/"
//     },
//     {
// ignore_for_file: non_constant_identifier_names



class PokemonListing {
  final int id;
  final String name;

  PokemonListing({required this.name, required this.id});

  factory PokemonListing.fromJson(Map<String, dynamic> json) {
    final name = json['name'];
    final url = json["url"] as String;
    final id = int.parse(url.split('/')[url.split('/').length - 2]);

    return PokemonListing(name: name, id: id);
  }
}

class PokemonPageResponnse {
  final bool canLoadNextPage;

  final List<PokemonListing>
  PokemonListings; //in this PokemonListings we have id and name of pokemon

  PokemonPageResponnse({
    required this.canLoadNextPage,
    required this.PokemonListings,
  });

  factory PokemonPageResponnse.fromJson(Map<String, dynamic> json) {
    final canLoadNextPage = json['next'] != null;
    final pokemonListings = (json['results'] as List)
        .map((listingjson) => PokemonListing.fromJson(listingjson))
        .toList();

    return PokemonPageResponnse(
      canLoadNextPage: canLoadNextPage,
      PokemonListings: pokemonListings,
    );
  }
}
