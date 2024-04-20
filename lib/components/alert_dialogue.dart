import 'package:flutter/material.dart';

class AlertDialogWithTextField extends StatefulWidget {
  final String title;
  final String hintText;
  final Function(String) onSubmit;

  const AlertDialogWithTextField({
    super.key,
    required this.title,
    required this.hintText,
    required this.onSubmit,
  });

  @override
  State<AlertDialogWithTextField> createState() =>
      _AlertDialogWithTextFieldState();
}

class _AlertDialogWithTextFieldState extends State<AlertDialogWithTextField> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _textController,
          decoration: InputDecoration(hintText: widget.hintText),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a value';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onSubmit(
                _textController.text,
              );

              Navigator.pop(context);
            }
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
