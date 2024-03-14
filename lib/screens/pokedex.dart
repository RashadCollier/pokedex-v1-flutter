import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rive/rive.dart';
import 'package:sandbox_app/models/quickactionscard.dart';

import '../data/sql_helper.dart';
import '../models/pokemon.dart';
import '../models/pokemonability.dart';

class PokedexScreen extends StatefulWidget {
  @override
  _PokedexScreenState createState() => _PokedexScreenState();
}

class _PokedexScreenState extends State<PokedexScreen> {
  int settingColor = 0xff78038C;
  SqlHelper sqlHelper = SqlHelper();
  late RiveAnimationController hasPokemon;
  late RiveAnimationController buttonPressed;
  late Future<Pokemon> futurePokemon;

  void playAnimation(RiveAnimationController controller) {
    if (controller.isActive == false) {
      controller.isActive = true;
    }
  }

  @override
  void initState() {
    super.initState();

    futurePokemon = sqlHelper.fetchPokeapiInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokedex'),
        backgroundColor: Colors.red.shade700,
      ),
      body: FutureBuilder(
        future: getPokedex(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Pokemon> pokemonList =
                snapshot.data == null ? [] : snapshot.data as List<Pokemon>;
            if (pokemonList.isEmpty) {
              return Container();
            } else {
              return Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/pixelated-background.jpeg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: ReorderableListView(
                  onReorder: (oldIndex, newIndex) async {},
                  children: [
                    for (final pokemon in pokemonList)
                      Dismissible(
                          key: Key(pokemon.id.toString()),
                          onDismissed: (direction) {
                            sqlHelper.deletePokemon(pokemon);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              image: const DecorationImage(
                                image: AssetImage(
                                    'assets/pixelated-background.jpeg'),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(7),
                              color: Colors.transparent,
                            ),
                            child: Card(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              margin: const EdgeInsets.all(5),
                              shadowColor: Colors.white70,
                              key: ValueKey(pokemon.position),
                              child: ListTile(
                                title: Text(
                                  pokemon.name[0].toUpperCase() +
                                      pokemon.name.substring(1),
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                subtitle: Text(
                                  pokemon.id.toString(),
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                leading: SizedBox(
                                  height: 75,
                                  width: 60,
                                  child: Hero(
                                    tag: "${pokemon.name}Pic",
                                    child: Image.network(
                                      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${pokemon.id}.png',
                                      loadingBuilder:
                                          (context, child, progress) {
                                        return progress == null
                                            ? child
                                            : const LinearProgressIndicator();
                                      },
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  //Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => ));
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => /*PokemonDetails(pokemon: pokemon,)*/
                                              Scaffold(
                                        appBar: AppBar(
                                            title: Text(
                                                pokemon.name[0].toUpperCase() +
                                                    pokemon.name.substring(1))),
                                        body: Center(
                                          child: Container(
                                            color: Colors.black26,
                                            child: Column(
                                              children: [
                                                Hero(
                                                  tag: "${pokemon.name} Pic",
                                                  child: Image.network(
                                                      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${pokemon.id}.png'),
                                                ),
                                                FutureBuilder<List<String>>(
                                                  future: Future.wait([
                                                    getPokemonFlavorText(
                                                      pokemon.id!,
                                                    ),
                                                    getPokemonType(pokemon.id!),
                                                    getPokemonAbilities(
                                                        pokemon.name),
                                                    getPokemonCaptureRate(
                                                        pokemon.id!),
                                                  ]),
                                                  builder: (
                                                    context,
                                                    snapshot,
                                                  ) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return const CircularProgressIndicator();
                                                    } else if (snapshot
                                                        .hasError) {
                                                      return Text(
                                                          'Error: ${snapshot.error}');
                                                    } else {
                                                      String? flavorText =
                                                          snapshot.data
                                                              ?.elementAt(0);
                                                      String? types = snapshot
                                                          .data
                                                          ?.elementAt(1);
                                                      String? abilities =
                                                          snapshot.data
                                                              ?.elementAt(2);
                                                      String? captureRate =
                                                          snapshot.data
                                                              ?.elementAt(3);
                                                      return Expanded(
                                                        child: SizedBox(
                                                          child: ListView(
                                                              shrinkWrap: true,
                                                              scrollDirection:
                                                                  Axis.vertical,
                                                              children: <Widget>[
                                                                QuickActionsCard(
                                                                  icon: Icons
                                                                      .question_mark,
                                                                  cardText:
                                                                      flavorText!,
                                                                ),
                                                                QuickActionsCard(
                                                                  icon: Icons
                                                                      .category,
                                                                  cardText:
                                                                      types!,
                                                                ),
                                                                QuickActionsCard(
                                                                  icon: Icons
                                                                      .accessibility,
                                                                  cardText:
                                                                      abilities!,
                                                                ),
                                                                QuickActionsCard(
                                                                  icon: Icons
                                                                      .percent,
                                                                  cardText:
                                                                      captureRate!,
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
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ))
                  ],
                ),
              );
            }
          }
        },
      ),
    );
  }

  Future<List<Pokemon>> getPokedex() async {
    sqlHelper = SqlHelper();
    List<Pokemon> pokedex = await sqlHelper.getPokedex();
    for (var i = 1; i < 151; i++) {
      pokedex.add(await getPokemon(i));
    }
    return pokedex;
  }

  Future<Pokemon> getPokemon(int i) async {
    http.Response response = await http
        .get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$i'), headers: {
      HttpHeaders.authorizationHeader: 'e1652fd2-86ce-4d92-8eeb-e3ad28ccf294',
    });

    if (response.statusCode == 200) {
      return Pokemon.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to pull Pokedex info");
    }
  }

  Future<String> getPokemonFlavorText(int i) async {
    http.Response response = await http
        .get(Uri.parse('https://pokeapi.co/api/v2/pokemon-species/$i'));
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

    String abilitiesList = "Abilities:";
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
    http.Response response = await http
        .get(Uri.parse('https://pokeapi.co/api/v2/pokemon-species/$i'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final int captureRate = jsonData['capture_rate'];

      return captureRate.toString();
    }

    return 'Pokemon description not found';
  }
}
