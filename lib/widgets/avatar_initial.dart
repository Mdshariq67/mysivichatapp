import 'package:flutter/material.dart';

class AvatarInitial extends StatelessWidget {
  final String name;
  final double size;
  const AvatarInitial({required this.name, this.size = 40});

  @override
  Widget build(BuildContext context) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: Colors.green,
      child: Text(initial, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }
}
