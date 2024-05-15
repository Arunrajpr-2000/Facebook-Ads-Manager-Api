import 'package:flutter/material.dart';
import 'package:just_ghar_facebook_post/model/ad_image_model.dart';

class AdImageDetailScreen extends StatelessWidget {
  final AdImageDataModel adImageDataModel;

  const AdImageDetailScreen({super.key, required this.adImageDataModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ad Image Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      adImageDataModel.url ?? '',
                      fit: BoxFit.cover,
                      // height: 400.0,
                    ),
                  ),
                  // if (adImageDataModel.hash ==
                  //     "4211f540b482ad14a17356d6f54a39a8")
                  //   Positioned(
                  //     bottom: 100,
                  //     left: 15,
                  //     child: Container(
                  //       color: Colors.red,
                  //       padding: EdgeInsets.symmetric(horizontal: 10),
                  //       child: const Text(
                  //         'Special Offer',
                  //         style: TextStyle(
                  //           fontSize: 18.0,
                  //           fontWeight: FontWeight.w400,
                  //           color: Colors.white,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // if (adImageDataModel.hash ==
                  //     "4211f540b482ad14a17356d6f54a39a8")
                  //   Positioned(
                  //     bottom: 150,
                  //     child: SizedBox(
                  //       height: 100,
                  //       width: 100,
                  //       child: Image.asset(
                  //         "assets/special-offer-png-4457.png",
                  //       ),
                  //     ),
                  //   )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ID: ${adImageDataModel.id}',
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Hash: ${adImageDataModel.hash}',
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
