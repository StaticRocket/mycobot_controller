import 'package:flutter/material.dart';

class DiagramCard extends StatefulWidget {
  const DiagramCard({super.key});

  @override
  State<DiagramCard> createState() => _DiagramCardState();
}

class _DiagramCardState extends State<DiagramCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
            padding: const EdgeInsets.all(8),
            child: Center(
                child: const Image(image: AssetImage('assets/diagram.png')))));
  }
}
