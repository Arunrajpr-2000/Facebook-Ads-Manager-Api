// ignore_for_file: avoid_print, use_build_context_synchronously
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:just_ghar_facebook_post/core/functions.dart';
import 'package:just_ghar_facebook_post/widgets/elevated_button_widget.dart';
import 'package:video_player/video_player.dart';

class FacebookPostVideo extends StatefulWidget {
  const FacebookPostVideo({super.key});

  @override
  FacebookPostVideoState createState() => FacebookPostVideoState();
}

class FacebookPostVideoState extends State<FacebookPostVideo> {
  String? videoPath;
  String caption = 'Caption';
  TextEditingController controller = TextEditingController();
  bool isLoading = false;
  late VideoPlayerController videoPlayerController;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.file(File(''));
  }

  Future<void> selectVideo() async {
    videoPath = await pickVideo();
    if (videoPath != null) {
      videoPlayerController = VideoPlayerController.file(File(videoPath!))
        ..initialize().then((_) {
          setState(() {});
        });
    } else {
      setState(() {});
    }
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Facebook Post Video',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey,
                ),
                child: videoPath == null
                    ? const Image(
                        image: AssetImage('assets/10832788.jpg'),
                        fit: BoxFit.cover,
                      )
                    : AspectRatio(
                        aspectRatio: videoPlayerController.value.aspectRatio,
                        child: VideoPlayer(videoPlayerController),
                      ),
              ),
              const SizedBox(height: 50),
              SizedBox(
                width: 250,
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(hintText: 'Add Caption'),
                  onChanged: (value) {
                    setState(() {
                      caption = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButtonWidget(
                onPressed: selectVideo,
                buttonText: 'Select Video',
              ),
              const SizedBox(height: 20),
              isLoading == false
                  ? ElevatedButtonWidget(
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        await postVideoToFacebook(videoPath, caption, context);
                        setState(() {
                          isLoading = false;
                        });
                      },
                      buttonText: 'Post Video to Facebook',
                    )
                  : const CircularProgressIndicator(),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
