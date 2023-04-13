import 'package:flutter/material.dart';

class MenuOption extends StatelessWidget {
  final String text;
  final String image;
  final Widget content;
  final bool isSelected;

  MenuOption(this.text, this.image, this.content, this.isSelected);

  @override
  Widget build(BuildContext context) {
    return getMenuOption(text, image);
  }

  Column getMenuOption(String text, String image) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 10),
        Image.asset(image, width: 32, height: 32, color: isSelected ? Colors.amber : Colors.white,),
        Text(text, style: TextStyle(color: isSelected ? Colors.amber : Colors.white)),
        const SizedBox(height: 10),
      ],
    );
  }
}