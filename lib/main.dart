import 'package:flutter/material.dart';
import 'package:just_ghar_facebook_post/view/campaign_list_screen/campaign_list_screen.dart';
import 'package:just_ghar_facebook_post/view/lead_gen_form/lead_form_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const FacebookCampaigns(),
    );
  }
}
