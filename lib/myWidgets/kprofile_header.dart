import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  ProfileHeader({required this.image});
  final String image;
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          top: 0,
          child: Container(
            width: 100,
            height: 100,
            child: Image(
              image: AssetImage(image),
            ),
          ),
        ),
      ],
    ));
  }
}
