

class SelectedPokemonSpeciesResponse {
  final String description;

  final String growthRate;

  SelectedPokemonSpeciesResponse({
    required this.description,

    required this.growthRate,
  });

  factory SelectedPokemonSpeciesResponse.fromJson(Map<String, dynamic> json) {
    final description = json['flavor_text_entries'][0]['flavor_text'];

    final growthRate = json['growth_rate']['name'];

    return SelectedPokemonSpeciesResponse(
      description: description,

      growthRate: growthRate,
    );
  }
}

class SelectedPokemonResponseInfo {
  final int height;
  final int id;
  final int weight;
  final String name;
  final List<String> types;
  final String imageURL;
  SelectedPokemonResponseInfo({
    required this.height,
    required this.id,
    required this.weight,
    required this.name,
    required this.types,
    required this.imageURL,
  });

  factory SelectedPokemonResponseInfo.fromJson(Map<String, dynamic> json) {
    var id = json['id'];
    var name = json['name'];
    var height = json['height'];
    var weight = json['weight'];
    var imageURL = json["sprites"]["front_default"];

    return SelectedPokemonResponseInfo(
      height: height,
      id: id,
      weight: weight,
      name: name,
      types: (json['types'] as List)
          .map((t) => t['type']['name'] as String)
          .toList(),
      imageURL: imageURL,
    );
  }
}