import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:sandbox_app/models/pokemon.dart';
import 'package:sqflite/sqflite.dart';

class SqlHelper {
  final String colId = 'id';
  final String colName = 'name';
  final String colNumber = 'number';
  final String colTypes = 'type';
  final String colWeight = 'weight';
  final String colPosition = 'position';
  final String tablePokedex = 'pokedex';

  static Database? _db;

  SqlHelper._internal();

  static SqlHelper _singleton = SqlHelper._internal();

  factory SqlHelper() {
    return _singleton;
  }

  Future<Database?> get database async {
    if (_db != null) return _db;

    _db = await init();
    return _db;
  }

  Future<Database> init() async {
    final databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, 'pokedex.db');
    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: _createDb,
    );
  }

  Future _createDb(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $tablePokedex($colId INTEGER PRIMARY KEY, $colName TEXT, $colNumber TEXT, $colTypes TEXT, $colWeight INTEGER, $colPosition INTEGER)');
  }

  Future<List<Pokemon>> getPokedex() async {
    _db = await init();
    List<Map<String, dynamic>> pokemonList =
        await _db!.query(tablePokedex, orderBy: colPosition);
    List<Pokemon> pokedex = [];
    for (var element in pokemonList) {
      pokedex.add(Pokemon.fromMap(element));
    }
    return pokedex;
  }

  Future<int> insertPokemon(Pokemon pokemon) async {
    int result = await _db!.insert(tablePokedex, pokemon.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return result;
  }

  Future<int> updatePokemon(Pokemon pokemon) async {
    int result = await _db!.update(tablePokedex, pokemon.toMap(),
        where: '$colId =?', whereArgs: [pokemon.id]);
    return result;
  }

  Future<int> deletePokemon(Pokemon pokemon) async {
    int result = await _db!
        .delete(tablePokedex, where: '$colId = ?', whereArgs: [pokemon.id]);
    return result;
  }

  Future<Pokemon> fetchPokeapiInfo() async {
    http.Response response = await http
        .get(Uri.parse('https://pokeapi.co/api/v2/pokemon/1'), headers: {
      HttpHeaders.authorizationHeader: 'application/json; charset=utf-8',
    });
    if (response.statusCode == 200) {
      final parsedPokemon = jsonDecode(response.body);
      Pokemon pokemon = Pokemon.fromJson(parsedPokemon);

      return pokemon;
    } else {
      throw Exception("Failed to pull Pokedex info");
    }
  }
}
