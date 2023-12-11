import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_app/bloc/pin_bloc.dart';
import 'package:pin_code_app/bloc/pin_event.dart';
import 'package:pin_code_app/screens/pin_confirmation_screen.dart';
import 'package:pin_code_app/widgets/pin_input_field.dart';

class PinEntryScreen extends StatefulWidget {
  const PinEntryScreen({super.key});

  @override
  PinEntryScreenState createState() => PinEntryScreenState();
}

class PinEntryScreenState extends State<PinEntryScreen> {
  final _pinControllers = List.generate(4, (_) => TextEditingController());
  final _pinFocusNodes = List.generate(4, (_) => FocusNode());

  @override
  void dispose() {
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
          title: const Text('Enter Your PIN'),
        ),
        body: Center(
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
                  onPressed: _onSubmitPressed,
                  child: const Text('Submit PIN'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onSubmitPressed() async {
    final pin = _pinControllers.map((c) => c.text).join();
    context.read<PinBloc>().add(PinEntered(pin));
    _navigateAndReset();
  }

  void _navigateAndReset() async {
    bool? result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const PinConfirmationScreen()),
    );

    if (result != null && result) {
      for (var element in _pinControllers) {
        element.clear();
      }
    }
  }
}
