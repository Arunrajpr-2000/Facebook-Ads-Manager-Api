import 'package:flutter/material.dart';
import 'package:just_ghar_facebook_post/view/ad_creative_screen/ad_creative_list_screen.dart';
import 'package:just_ghar_facebook_post/view/ad_images_list_screen/ad_image_list_screen.dart';
import 'package:just_ghar_facebook_post/view/campaign_list_screen/campaign_list_screen.dart';
import 'package:just_ghar_facebook_post/view/edit_image_template/edit_image_template.dart';
import 'package:just_ghar_facebook_post/view/facebook_post_feed/facebook_post_home_screen.dart';
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
            accountEmail: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Just Ghar Page'),
                Text('vithamastech1@gmail.com'),
              ],
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://scontent.fblr1-8.fna.fbcdn.net/v/t39.30808-1/309418618_519255106876369_5038763566503765362_n.jpg?stp=dst-jpg_p480x480&_nc_cat=101&ccb=1-7&_nc_sid=5f2048&_nc_ohc=EBdPuuZ2rOwQ7kNvgHjFsON&_nc_ht=scontent.fblr1-8.fna&oh=00_AYBlhuPPFgOdoRbgP1JH04sYBzyZfmrAy0s2N7UDjqzXtw&oe=664B9718'),
            ),
          ),
          _createDrawerItem(
            icon: Icons.campaign,
            text: 'Campaign',
            onTap: () => _navigateToScreen(context, const FacebookCampaigns()),
          ),
          _createDrawerItem(
            icon: Icons.assignment,
            text: 'Lead Forms',
            onTap: () => _navigateToScreen(context, const LeadFormListScreen()),
          ),
          _createDrawerItem(
            icon: Icons.add_reaction,
            text: 'Ad Creative',
            onTap: () =>
                _navigateToScreen(context, const AdCreativeListScreen()),
          ),
          _createDrawerItem(
            icon: Icons.photo,
            text: 'Ads Images',
            onTap: () => _navigateToScreen(context, const AdImageListScreen()),
          ),
          _createDrawerItem(
            icon: Icons.tune,
            text: 'Edit Ads Image',
            onTap: () => _navigateToScreen(context, const EditImageTemplate()),
          ),
          _createDrawerItem(
            icon: Icons.add_photo_alternate,
            text: 'Post Feed On Facebook',
            onTap: () =>
                _navigateToScreen(context, const FacebookPostHomeScreen()),
          ),
        ],
      ),
    );
  }

  Widget _createDrawerItem({
    required IconData icon,
    required String text,
    required GestureTapCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: () {
        Scaffold.of(context).closeDrawer();
        onTap();
      },
    );
  }

  void _navigateToScreen(BuildContext context, Widget screen) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => screen));
  }
}
