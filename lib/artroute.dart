import 'package:flutter/material.dart';
import 'package:sandbox_app/utils/art_util.dart';

class ArtRoute extends StatelessWidget {
  final String art;
  ArtRoute({required this.art});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigator'),
        actions: <Widget>[
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return Util.menuItems.map((String item) {
                return PopupMenuItem<String>(
                  child: Text(item),
                  value: item,
                );
              }).toList();
            },
            onSelected: (String value) => changeRoute(context, value),
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
            image:
                DecorationImage(image: NetworkImage(art), fit: BoxFit.cover)),
      ),
    );
  }

  void changeRoute(BuildContext context, String menuItem) {
    String imagepath = "";
    switch (menuItem) {
      case Util.FIRSTPIC:
        {
          imagepath = Util.IMG_1STPIC;
          break;
        }
      case Util.SECONDPIC:
        {
          imagepath = Util.IMG_2NDPIC;
          break;
        }
      case Util.THIRDPIC:
        {
          imagepath = Util.IMG_3RDPIC;
          break;
        }
    }
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ArtRoute(
                  art: imagepath,
                )));
  }
}
