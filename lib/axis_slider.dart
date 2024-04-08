import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class AxisSlider extends StatefulWidget {
  const AxisSlider({super.key, required this.axis, required this.sendMessage});
  final String axis;
  final Function sendMessage;

  @override
  State<AxisSlider> createState() => _AxisSliderState();
}

class _AxisSliderState extends State<AxisSlider> {
  double degree = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Card(
            child: Column(children: [
      Padding(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Text(widget.axis),
      ),
      RotatedBox(
          quarterTurns: 3,
          child: Slider(
              value: degree,
              min: -120,
              max: 120,
              onChanged: _updateDegree,
              onChangeEnd: _sendMessage)),
      Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Text(degree.toStringAsFixed(0)),
      )
    ])));
  }

  void _updateDegree(updatedValue) {
    setState(() {
      degree = updatedValue;
    });
  }

  void _sendMessage(updatedValue) {
    widget.sendMessage('G1 ${widget.axis}${degree.toStringAsFixed(0)}');
  }
}
