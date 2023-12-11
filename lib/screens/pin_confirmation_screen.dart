import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_app/bloc/pin_bloc.dart';
import 'package:pin_code_app/bloc/pin_event.dart';
import 'package:pin_code_app/bloc/pin_state.dart';
import 'package:pin_code_app/widgets/pin_input_field.dart';

class PinConfirmationScreen extends StatefulWidget {
  const PinConfirmationScreen({super.key});

  @override
  PinConfirmationScreenState createState() => PinConfirmationScreenState();
}

class PinConfirmationScreenState extends State<PinConfirmationScreen> {
  Timer? _timer;
  final _pinControllers = List.generate(4, (_) => TextEditingController());
  final _pinFocusNodes = List.generate(4, (_) => FocusNode());

  @override
  void dispose() {
    _timer?.cancel();

    for (var controller in _pinControllers) {
      controller.dispose();
    }
    for (var focusNode in _pinFocusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Confirm Your PIN'),
        ),
        body: BlocListener<PinBloc, PinState>(
          listener: (context, state) {
            if (state is PinMatch) {
              _showSuccessDialog();
            } else if (state is PinMismatch) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('PIN does not match. Try again.')));
              _timer = Timer(const Duration(seconds: 2), () {
                resetApp();
              });
            }
          },
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(4, (index) {
                      return PinInputField(
                        controller: _pinControllers[index],
                        focusNode: _pinFocusNodes[index],
                        nextFocusNode:
                            index < 3 ? _pinFocusNodes[index + 1] : null,
                        previousFocusNode:
                            index > 0 ? _pinFocusNodes[index - 1] : null,
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _onConfirmPressed,
                    child: const Text('Confirm PIN'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void resetApp() {
    for (var element in _pinControllers) {
      element.clear();
    }
    context.read<PinBloc>().add(PinReset());
    Navigator.of(context).pop(true);
  }

  void _onConfirmPressed() {
    final confirmedPin = _pinControllers.map((c) => c.text).join();
    context.read<PinBloc>().add(PinConfirmed(confirmedPin));
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('PIN Confirmed'),
        content: const Text('The PIN codes match.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              resetApp();
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
