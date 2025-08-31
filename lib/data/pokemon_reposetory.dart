// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pokedex/data/pokemon_page_response.dart';

import 'package:pokedex/data/selected_pokemon_response.dart';

class PokemonReposetory {
  var baseUrl = "pokeapi.co";

  var path = '/api/v2/pokemon';

  Future<PokemonPageResponnse> getPokemonHomePage(int pageIndex) async {
    // pokemon?limit=200&offset=0

    var queryParameter = {
      'limit': '200',
      'offset': (pageIndex * 200).toString(),
    };

    var uri = Uri.https(baseUrl, path, queryParameter);

    var response = await http.get(uri);
    var json = jsonDecode(response.body);

    return PokemonPageResponnse.fromJson(
      json,
    ); // yha PokemonPageResponse ko use krke uske andr json ko put kr diya
  }

  Future<SelectedPokemonResponseInfo> getPokemonInfoBP(int pokemonId) async {
    try {
      var uri = Uri.https(baseUrl, '/api/v2/pokemon/$pokemonId');

      var response = await http.get(uri);
      var json = jsonDecode(response.body);

      return SelectedPokemonResponseInfo.fromJson(json);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<SelectedPokemonSpeciesResponse> getPokemonAboutBP(
    int pokemonId,
  ) async {
    try {
      var uri = Uri.https(baseUrl, '/api/v2/pokemon-species/$pokemonId');

      var response = await http.get(uri);
      var json = jsonDecode(response.body);

      return SelectedPokemonSpeciesResponse.fromJson(json);
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
