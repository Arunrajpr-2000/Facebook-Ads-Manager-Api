import 'package:flutter/material.dart';
import 'package:just_ghar_facebook_post/view/facebook_post_feed/facebook_post_image_feed.dart';
import 'package:just_ghar_facebook_post/view/facebook_post_feed/facebook_post_text_feed.dart';
import 'package:just_ghar_facebook_post/view/facebook_post_feed/facebook_post_video_feed.dart';
import 'package:just_ghar_facebook_post/widgets/drawer_widget.dart';
import 'package:just_ghar_facebook_post/widgets/elevated_button_widget.dart';

class FacebookPostHomeScreen extends StatefulWidget {
  const FacebookPostHomeScreen({super.key});

  @override
  State<FacebookPostHomeScreen> createState() => _FacebookPostHomeScreenState();
}

class _FacebookPostHomeScreenState extends State<FacebookPostHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Post On Facebook"),
      ),
      drawer: const DrawerWidget(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButtonWidget(
              buttonText: 'Post Text On Facebook Page',
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const FacebookPostText(),
                ));
              },
            ),
            const SizedBox(height: 30),
            ElevatedButtonWidget(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const FacebookPostImage(),
                ));
              },
              buttonText: 'Post Image On Facebook Page',
            ),
            const SizedBox(height: 30),
            ElevatedButtonWidget(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const FacebookPostVideo(),
                  ));
                },
                buttonText: 'Post Video On Facebook Page'),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
