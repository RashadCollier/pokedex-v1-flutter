import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/pokemon.dart';
import '../models/pokemonability.dart';
import '../models/quickactionscard.dart';

class PokemonDetails extends StatefulWidget {
  final Pokemon pokemon;

  PokemonDetails({super.key, required this.pokemon});

  @override
  State<PokemonDetails> createState() => _PokemonDetailsState();
}

class _PokemonDetailsState extends State<PokemonDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.pokemon.name[0].toUpperCase() +
              widget.pokemon.name.substring(1))),
      body: Center(
        child: Container(
          color: Colors.black26,
          child: Column(
            children: [
              Hero(
                tag: "${widget.pokemon.name} Pic",
                child: Image.network(
                    'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${widget.pokemon.id}.png'),
              ),
              FutureBuilder<List<String>>(
                future: Future.wait([
                  getPokemonFlavorText(widget.pokemon.id!),
                  getPokemonFlavorText(
                    widget.pokemon.id!,
                  ),
                  getPokemonType(widget.pokemon.id!),
                  getPokemonAbilities(widget.pokemon.name),
                  getPokemonCaptureRate(widget.pokemon.id!),
                ]),
                builder: (
                  context,
                  snapshot,
                ) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    String? flavorText = snapshot.data?.elementAt(0);
                    String? types = snapshot.data?.elementAt(1);
                    String? abilities = snapshot.data?.elementAt(2);
                    String? captureRate = snapshot.data?.elementAt(3);
                    return Expanded(
                      child: SizedBox(
                        child: ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            children: <Widget>[
                              QuickActionsCard(
                                icon: Icons.question_mark,
                                cardText: flavorText!,
                              ),
                              QuickActionsCard(
                                icon: Icons.category,
                                cardText: types!,
                              ),
                              QuickActionsCard(
                                icon: Icons.accessibility,
                                cardText: abilities!,
                              ),
                              QuickActionsCard(
                                icon: Icons.percent,
                                cardText: captureRate!,
                              ),
                            ]),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<String> getPokemonFlavorText(int i) async {
  http.Response response =
      await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon-species/$i'));
  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    final List flavorTextEntries = jsonData['flavor_text_entries'];
    final List englishEntries = flavorTextEntries.where((entry) {
      return entry['language']['name'] == 'en';
    }).toList();

    if (englishEntries.isNotEmpty) {
      final flavorText = englishEntries.first['flavor_text'];
      return flavorText;
    }
  }

  return 'Pokemon description not found';
}

Future<String> getPokemonType(int i) async {
  http.Response response =
      await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$i'));
  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    final List typesEntries = jsonData['types'];
    List<String> types = [];

    types = typesEntries.map((type) {
      final String typeName = type['type']['name'];
      return typeName;
    }).toList();

    if (types.first == types.last) {
      return types.first;
    } else if (types.first != types.last) {
      return '${types.first}/${types.last}';
    } else {
      return 'API error';
    }
  } else {
    return 'Pokemon type not found';
  }
}

Future<String> getPokemonAbilities(String pokemonName) async {
  final response = await http
      .get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$pokemonName/'));

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    final List<dynamic> abilitiesData = jsonData['abilities'];

    final List<PokemonAbility> abilities = abilitiesData.map((ability) {
      final name = ability['ability']['name'];
      final url = ability['ability']['url'];
      return PokemonAbility(name, url);
    }).toList();

    return '${abilities[0].name}/${abilities[1].name}';
  } else {
    return 'Error obtaining Abilities';
  }
}

Future<String> getPokemonCaptureRate(int i) async {
  http.Response response =
      await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon-species/$i'));
  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    final int captureRate = jsonData['capture_rate'];

    return captureRate.toString();
  }

  return 'Pokemon description not found';
}
