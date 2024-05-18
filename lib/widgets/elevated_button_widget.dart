import 'package:flutter/material.dart';

class ElevatedButtonWidget extends StatelessWidget {
  final void Function()? onPressed;
  final String buttonText;
  const ElevatedButtonWidget(
      {super.key, required this.onPressed, required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: const ButtonStyle(
            // backgroundColor: MaterialStatePropertyAll(Colors.blue),
            ),
        onPressed: onPressed,
        child: Text(
          buttonText,
          // style: const TextStyle(color: Colors.white),
        ));
  }
}
