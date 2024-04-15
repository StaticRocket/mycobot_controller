import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class AxisSliderCard extends StatefulWidget {
  const AxisSliderCard({
    super.key,
    required this.getAxis,
    required this.setAxis,
  });
  final Function getAxis;
  final Function setAxis;

  @override
  State<AxisSliderCard> createState() => _AxisSliderCardState();
}

class _AxisSliderCardState extends State<AxisSliderCard> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Card(
            child: Row(children: [
      AxisSlider(getAxis: widget.getAxis, setAxis: widget.setAxis, axis: 'X'),
      AxisSlider(getAxis: widget.getAxis, setAxis: widget.setAxis, axis: 'Y'),
      AxisSlider(getAxis: widget.getAxis, setAxis: widget.setAxis, axis: 'Z'),
      AxisSlider(getAxis: widget.getAxis, setAxis: widget.setAxis, axis: 'A'),
      AxisSlider(getAxis: widget.getAxis, setAxis: widget.setAxis, axis: 'B'),
      AxisSlider(getAxis: widget.getAxis, setAxis: widget.setAxis, axis: 'C'),
    ])));
  }
}

class AxisSlider extends StatefulWidget {
  const AxisSlider(
      {super.key,
      required this.axis,
      required this.getAxis,
      required this.setAxis});
  final String axis;
  final Function getAxis;
  final Function setAxis;

  @override
  State<AxisSlider> createState() => _AxisSliderState();
}

class _AxisSliderState extends State<AxisSlider> {
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
                value: widget.getAxis(widget.axis),
                min: -120,
                max: 120,
                onChanged: (updateValue) {
                  setState(() {
                    widget.setAxis(widget.axis, updateValue, false);
                  });
                },
                onChangeEnd: (updateValue) {
                  widget.setAxis(widget.axis, updateValue, true);
                })),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Text(widget.getAxis(widget.axis).toStringAsFixed(0)),
      )
    ])));
  }
}
