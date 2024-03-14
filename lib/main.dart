import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rive/rive.dart';
import 'package:sandbox_app/screens/mapScreen.dart';
import 'package:sandbox_app/screens/pokedex.dart';

void main() {
  runApp(MaterialApp(
    home: const SandboxApp(),
    theme: ThemeData(fontFamily: 'Munro'),
  ));
}

class SandboxApp extends StatelessWidget {
  const SandboxApp({super.key});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
      return Directionality(
        textDirection: TextDirection.ltr,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.deepPurple.shade200,
            title: const Text("Sandbox App"),
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                const DrawerHeader(
                  child: Text(
                    'Menu',
                    style: TextStyle(color: Colors.black, fontSize: 24),
                  ),
                ),
                ListTile(
                  title: const Text('Pokedex'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PokedexScreen()));
                  },
                ),
                /*ListTile(
                  title: const Text('Poke Info Screen'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RiveScreen()));
                  },
                ),*/
                ListTile(
                  title: const Text('Button'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ButtonScreen()));
                  },
                ),
                ListTile(
                  title: const Text('Map'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MapScreen()));
                  },
                ),
              ],
            ),
          ),
          body: Stack(children: [
            Image.asset(
              'assets/clouds.gif',
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height,
            ),
            const RiveAnimation.asset(
              "assets/transparentpokeballflash.riv",
              fit: BoxFit.cover,
              artboard: 'Artboard',
            ),
          ]),
        ),
      );
    });
  }
}

class ButtonScreen extends StatelessWidget {
  const ButtonScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var info;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Button'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // info = PokedexScreen.getPokeinfoFromApi(1);
            Future<http.Response> results =
                http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/1'));
            print(results.toString());
          },
          child: Text('Pull Pokedex info $info'),
        ),
      ),
    );
  }
}

class ResponseButton extends StatefulWidget {
  const ResponseButton({Key? key}) : super(key: key);

  @override
  State<ResponseButton> createState() => _ResponseButtonState();
}

class _ResponseButtonState extends State<ResponseButton> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Button'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            for (int i = 0; i < 10; i++) {}
          },
          child: const Text("Pull Pokedex info"),
        ),
      ),
    );
  }
}

class RiveScreen extends StatefulWidget {
  const RiveScreen({Key? key}) : super(key: key);

  @override
  State<RiveScreen> createState() => _RiveScreenState();
}

class _RiveScreenState extends State<RiveScreen> {
  bool hasPokemon = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Test Page"),
        ),
      ),
      body: const Center(
        child: Scaffold(
          backgroundColor: Colors.white70,
          body: Center(
            child: Column(
              children: [],
            ),
          ),
        ),
      ),
    );
  }
}
