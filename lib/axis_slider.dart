import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class AxisSliderCard extends StatefulWidget {
  const AxisSliderCard({super.key, required this.sendMessage});
  final Function sendMessage;

  @override
  State<AxisSliderCard> createState() => _AxisSliderCardState();
}

class _AxisSliderCardState extends State<AxisSliderCard> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Card(
            child: Row(children: [
      AxisSlider(sendMessage: widget.sendMessage, axis: 'X'),
      AxisSlider(sendMessage: widget.sendMessage, axis: 'Y'),
      AxisSlider(sendMessage: widget.sendMessage, axis: 'Z'),
      AxisSlider(sendMessage: widget.sendMessage, axis: 'A'),
      AxisSlider(sendMessage: widget.sendMessage, axis: 'B'),
      AxisSlider(sendMessage: widget.sendMessage, axis: 'C'),
    ])));
  }
}

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
      Flexible(
        child: RotatedBox(
            quarterTurns: 3,
            child: Slider(
                value: degree,
                min: -120,
                max: 120,
                onChanged: _updateDegree,
                onChangeEnd: _sendMessage)),
      ),
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
