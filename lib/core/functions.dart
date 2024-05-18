// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:just_ghar_facebook_post/components/utils.dart';
import 'package:just_ghar_facebook_post/core/const.dart';

// facebook post image feed to page-------------------------------->
Future<void> postImageToFacebook(
    String? imageLocation, String caption, context) async {
  if (imageLocation == null) {
    print('No image selected');
    snackBarWidget(context, 'select image');
    return;
  }

  try {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://graph.facebook.com/v19.0/me/photos'),
    );
    request.fields['caption'] = caption;
    request.fields['access_token'] = pageAccessToken;

    var file = await http.MultipartFile.fromPath('source', imageLocation);
    request.files.add(file);

    var response = await request.send();
    if (response.statusCode == 200) {
      print('Image posted successfully!');
      snackBarWidget(context, 'Image posted successfully!');
    } else {
      print('Failed to post image. Status code: ${response.statusCode}');
      snackBarWidget(
          context, 'Failed to post image. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
    snackBarWidget(context, 'Error : $e');
  }
}

// pick image to post on fb page-------------------------------------->
Future<String?> pickImage() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    return pickedFile.path;
  }
  return null;
}

// facebook post Text feed to page-------------------------------->
Future<void> postTextFeed(String message, BuildContext context) async {
  try {
    // Create the URL for the feed POST request
    var url = Uri.parse('https://graph.facebook.com/$pageId/feed');

    // Create the request body
    var body = {
      'message': message,
      'access_token': pageAccessToken,
    };

    // Send the POST request
    var response = await http.post(url, body: body);

    // Check the response status code
    if (response.statusCode == 200) {
      print('Text feed posted successfully!');
      snackBarWidget(context, 'Text feed posted successfully!');
    } else {
      print('Failed to post text feed. Status code: ${response.statusCode}');

      snackBarWidget(context,
          'Failed to post text feed. Status code: ${response.statusCode}');
    }
  } catch (e) {
    // Handle any exceptions
    print('Error: $e');
    snackBarWidget(context, 'Error : $e');
  }
}

// pick Video to post on fb page-------------------------------------->
Future<String?> pickVideo() async {
  final result = await ImagePicker().pickVideo(
    source: ImageSource.gallery,
    maxDuration: const Duration(minutes: 2),
  );

  if (result != null) {
    return result.path;
  }

  return null;
}

// facebook post Video feed to page-------------------------------->
Future<void> postVideoToFacebook(
    String? videoPath, String caption, BuildContext context) async {
  if (videoPath == null) {
    print('No video selected');
    snackBarWidget(context, 'No video selected');
    return;
  }

  try {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://graph.facebook.com/v19.0/me/videos'),
    );

    request.fields['caption'] = caption;
    request.fields['access_token'] = pageAccessToken;

    // Add the video file to the request
    var file = await http.MultipartFile.fromPath('source', videoPath);
    request.files.add(file);

    var response = await request.send();

    if (response.statusCode == 200) {
      print('Video posted successfully!');
      snackBarWidget(context, 'Video posted successfully!');
    } else {
      print('Failed to post video. Status code: ${response.statusCode}');
      snackBarWidget(
          context, 'Failed to post video. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
    snackBarWidget(context, 'Error: $e');
  }
}
