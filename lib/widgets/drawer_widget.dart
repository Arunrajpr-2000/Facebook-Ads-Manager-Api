import 'package:flutter/material.dart';
import 'package:just_ghar_facebook_post/view/ad_images_list_screen/ad_image_list_screen.dart';
import 'package:just_ghar_facebook_post/view/edit_image_template/edit_image_template.dart';
import 'package:just_ghar_facebook_post/view/lead_gen_form/lead_form_list.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const UserAccountsDrawerHeader(
            arrowColor: Colors.black,
            currentAccountPictureSize: Size(60, 60),
            decoration:
                BoxDecoration(color: Color.fromARGB(255, 154, 152, 152)),
            accountName: Text('Vithamas S'),
            accountEmail: Text('vithamastech1@gmail.com'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTzuywOjCTV38_Gl8qcgf4sSGaFrlc5EoaNgRMfHeWwZA&s'),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.note),
            title: const Text('Lead Forms'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const LeadFormListScreen(),
              ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo),
            title: const Text('Ads Images'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const AdImageListScreen(),
              ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_filter),
            title: const Text('Edit Ads Image'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const EditImageTemplate(),
              ));
            },
          ),
        ],
      ),
    );
  }
}
