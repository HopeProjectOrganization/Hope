import 'package:flutter/material.dart';

class CircleInput extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  const CircleInput({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    super.key,
    required Null Function() onDeleted,
  });

  @override
  CircleInputState createState() => CircleInputState();
}

class CircleInputState extends State<CircleInput> {
  bool isFilled = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      setState(() {
        isFilled = widget.controller.text.isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: isFilled ? const Color(0xff8E56FF) : const Color(0xffC9C9C9),
        // Color changes based on input
        shape: BoxShape.circle,
      ),
      child: Center(
        child: TextField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          style: const TextStyle(fontSize: 24, color: Colors.white),
          decoration: const InputDecoration(
            isCollapsed: true,
            contentPadding: EdgeInsets.all(0),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            counterText: '',
          ),
          onChanged: widget.onChanged,
        ),
      ),
    );
  }
}
