import 'package:flutter/material.dart';

class QuickActionsCard extends StatelessWidget {
  final IconData icon;
  final void Function()? onTap;
  final String cardText;

  const QuickActionsCard({
    Key? key,
    required this.icon,
    this.onTap,
    required this.cardText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.only(left: 10),
        elevation: 0.0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
          side: BorderSide(
            color: Colors.blueGrey,
            width: 1,
          ),
        ),
        color: Colors.white70,
        child: SizedBox(
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 10),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                    ),
                    Icon(
                      icon,
                      color: Colors.red,
                      size: 30.0,
                    ),
                    const SizedBox(
                      height: 7.0,
                    ),
                    Text(
                      cardText,
                      style: TextStyle(fontSize: 22, letterSpacing: 1),
                    ),
                  ],
                ),
              ),
              /*const Icon(
                Icons.chevron_right_rounded,
                size: 28.0,
              ),*/
              Padding(
                padding: EdgeInsets.only(bottom: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
