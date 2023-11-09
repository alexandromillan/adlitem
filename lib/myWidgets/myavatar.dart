import 'package:flutter/material.dart';

class Myavatar extends StatefulWidget {
  final String str;
  final double radius;

  Myavatar({Key? key, required this.str, required this.radius})
      : super(key: key);

  @override
  _MyavatarState createState() => _MyavatarState();
}

class _MyavatarState extends State<Myavatar> {
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.white70,
      radius: widget.radius,
      child: Text(
        widget.str.toUpperCase(),
        style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purple),
      ),
    );
  }
}
