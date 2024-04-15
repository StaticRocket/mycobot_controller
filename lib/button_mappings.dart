import 'dart:math';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ButtonCard extends StatefulWidget {
  const ButtonCard(
      {super.key,
      required this.sendMessage,
      required this.toggleDemo,
      required this.appendLog,
      required this.demoBool});
  final Function sendMessage;
  final Function toggleDemo;
  final Function appendLog;
  final bool demoBool;

  @override
  State<ButtonCard> createState() => _ButtonCardState();
}

class _ButtonCardState extends State<ButtonCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(children: [
              Column(children: [
                PositionButton(
                    icon: const Icon(Icons.home),
                    label: const Text("Home"),
                    sendMessage: () {
                      widget.sendMessage("G30");
                    }),
                const SizedBox(height: 8),
                PositionButton(
                    icon: const Icon(Icons.flash_on),
                    label: const Text("Power on motors"),
                    sendMessage: () {
                      widget.sendMessage("M80");
                    }),
                const SizedBox(height: 8),
                PositionButton(
                    icon: const Icon(Icons.flash_off),
                    label: const Text("Power off motors"),
                    sendMessage: () {
                      widget.sendMessage("M81");
                    }),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  icon: const Icon(Icons.games),
                  label: const Text("Rock, paper, scissors"),
                  onPressed: _rockPaperSissors,
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  icon: widget.demoBool
                      ? const Icon(Icons.pause)
                      : const Icon(Icons.play_arrow),
                  label: const Text("Demo mode"),
                  onPressed: () async {
                    await widget.toggleDemo();
                  },
                ),
              ])
            ])));
  }

  void _rockPaperSissors() {
    int selection = Random().nextInt(3);
    switch (selection) {
      case 0:
        widget.appendLog("~ I picked rock!");
        break;
      case 1:
        widget.appendLog("~ I picked paper!");
        break;
      case 2:
        widget.appendLog("~ I picked scissors!");
        break;
    }
  }
}

class PositionButton extends StatefulWidget {
  const PositionButton(
      {super.key,
      required this.icon,
      required this.label,
      required this.sendMessage});
  final Icon icon;
  final Text label;
  final Function sendMessage;

  @override
  State<PositionButton> createState() => _PositionButtonState();
}

class _PositionButtonState extends State<PositionButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: _sendMessage,
      icon: widget.icon,
      label: widget.label,
    );
  }

  void _sendMessage() {
    widget.sendMessage();
  }
}
