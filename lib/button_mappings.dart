import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ButtonCard extends StatefulWidget {
  const ButtonCard({super.key, required this.sendMessage});
  final Function sendMessage;

  @override
  State<ButtonCard> createState() => _ButtonCardState();
}

class _ButtonCardState extends State<ButtonCard> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Card(
            child: Row(mainAxisSize: MainAxisSize.max, children: [
      Column(mainAxisSize: MainAxisSize.max, children: [
        PositionButton(
            icon: const Icon(Icons.home),
            sendMessage: () {
              widget.sendMessage("G30");
            })
      ])
    ])));
  }
}

class PositionButton extends StatefulWidget {
  const PositionButton(
      {super.key, required this.icon, required this.sendMessage});
  final Icon icon;
  final Function sendMessage;

  @override
  State<PositionButton> createState() => _PositionButtonState();
}

class _PositionButtonState extends State<PositionButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _sendMessage,
      icon: widget.icon,
    );
  }

  void _sendMessage() {
    widget.sendMessage();
  }
}
