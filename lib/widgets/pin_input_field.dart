import 'package:flutter/material.dart';

class PinInputField extends StatelessWidget {
  final FocusNode focusNode;
  final TextEditingController controller;
  final FocusNode? nextFocusNode;
  final FocusNode? previousFocusNode;

  const PinInputField({
    Key? key,
    required this.focusNode,
    required this.controller,
    this.nextFocusNode,
    this.previousFocusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        obscureText: true,
        maxLength: 1,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(counterText: ''),
        onChanged: (value) {
          if (value.length == 1 && nextFocusNode != null) {
            FocusScope.of(context).requestFocus(nextFocusNode);
          } else if (value.isEmpty && previousFocusNode != null) {
            FocusScope.of(context).requestFocus(previousFocusNode);
          }
        },
      ),
    );
  }
}
