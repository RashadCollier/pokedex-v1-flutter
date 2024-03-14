import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:sandbox_app/screens/pokedex.dart';

import '../data/sql_helper.dart';
import '../models/pokemon.dart';

class PokemonInfo extends StatefulWidget {
  final riveFile = const RiveAnimation.asset('assets/pokeballflash.riv');
  final Pokemon pokemon;
  final bool isNew;

  PokemonInfo(this.pokemon, this.isNew);

  @override
  _PokemonInfoState createState() => _PokemonInfoState();
}

class _PokemonInfoState extends State<PokemonInfo> {
  int settingColor = 0xff78038C;
  double fontSize = 15;
  SqlHelper helper = SqlHelper();
  final TextEditingController txtName = TextEditingController();
  final TextEditingController txtTypes = TextEditingController();
  final TextEditingController txtNumber = TextEditingController();
  final TextEditingController txtWeight = TextEditingController();

  @override
  void initState() {
    if (!widget.isNew) {
      txtName.text = widget.pokemon.name;
      txtNumber.text = widget.pokemon.number;
      // txtTypes.text = widget.pokemon.type;
      txtWeight.text = widget.pokemon.weight;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.isNew
            ? const Text('Insert Pokemon')
            : const Text('Edit Pokemon'),
        backgroundColor: Color(settingColor),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            PokemonTextField('Name', txtName, fontSize),
            PokemonTextField('Order', txtNumber, fontSize),
            // PokemonTextField('Type', txtTypes, fontSize),
            PokemonTextField('Weight', txtWeight, fontSize),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Color(settingColor),
          onPressed: () {
            widget.pokemon.name = txtName.text;
            //  widget.pokemon.type = txtTypes.text;
            widget.pokemon.number = txtNumber.text;
            widget.pokemon.weight = txtWeight.text;
            widget.pokemon.position = 0;
            if (widget.isNew) {
              helper.insertPokemon(widget.pokemon);
            } else {
              helper.updatePokemon(widget.pokemon);
            }
            Navigator.pushReplacement((context),
                MaterialPageRoute(builder: (context) => PokedexScreen()));
            Navigator.pop(context);
          },
          child: const Icon(Icons.save)),
    );
  }
}

class PokemonTextField extends StatelessWidget {
  final String description;
  final TextEditingController controller;
  final double textSize;

  PokemonTextField(this.description, this.controller, this.textSize);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: TextField(
        controller: controller,
        style: TextStyle(
          fontSize: textSize,
        ),
        decoration: InputDecoration(
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
            hintText: description),
      ),
    );
  }
}
