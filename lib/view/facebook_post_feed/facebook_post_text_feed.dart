import 'package:flutter/material.dart';
import 'package:just_ghar_facebook_post/core/functions.dart';
import 'package:just_ghar_facebook_post/widgets/elevated_button_widget.dart';

class FacebookPostText extends StatefulWidget {
  const FacebookPostText({super.key});

  @override
  State<FacebookPostText> createState() => _FacebookPostTextState();
}

class _FacebookPostTextState extends State<FacebookPostText> {
  String message = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Facebook Post Text',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 250,
              child: TextField(
                decoration: const InputDecoration(hintText: 'Add Text...'),
                onChanged: (value) {
                  setState(() {
                    message = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            isLoading == false
                ? ElevatedButtonWidget(
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      await postTextFeed(message, context);
                      setState(() {
                        isLoading = false;
                      });
                    },
                    buttonText: 'Post Message',
                  )
                : const CircularProgressIndicator()
          ],
        ),
      ),
    );
  }
}
