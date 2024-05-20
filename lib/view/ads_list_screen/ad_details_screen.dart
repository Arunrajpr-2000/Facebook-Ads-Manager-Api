import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:just_ghar_facebook_post/components/utils.dart';
import 'package:just_ghar_facebook_post/core/const.dart';
import 'package:just_ghar_facebook_post/model/ads_model.dart';
import 'package:http/http.dart' as http;

class AdDetailScreen extends StatefulWidget {
  final AdsModel adsModel;

  const AdDetailScreen({super.key, required this.adsModel});

  @override
  State<AdDetailScreen> createState() => _AdDetailScreenState();
}

class _AdDetailScreenState extends State<AdDetailScreen> {
  String? adImageUrl = "";

  @override
  void initState() {
    super.initState();
    _getImageUrlFromHash(
        widget.adsModel.creative?.objectStorySpec?.linkData?.imageHash ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Ad Details",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageSection(),
              const SizedBox(height: 15),
              _buildDetailsCard(),
              const SizedBox(height: 16),
              _buildCreativeDetails(),
              const SizedBox(height: 16),
              _buildLeadDetails(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return FutureBuilder<String?>(
      future: _getImageUrlFromHash(
          widget.adsModel.creative?.objectStorySpec?.linkData?.imageHash ?? ""),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          final imageUrl = snapshot.data;
          return imageUrl != null
              ? Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Text('Error loading image'),
                    ),
                  ),
                )
              : const SizedBox.shrink();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildDetailsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('ID : ', widget.adsModel.id),
            const SizedBox(height: 8),
            _buildDetailRow('Name : ', widget.adsModel.name),
            const SizedBox(height: 8),
            _buildDetailRow('Adset ID : ', widget.adsModel.adsetId),
            const SizedBox(height: 8),
            _buildDetailRow('Status : ', widget.adsModel.status),
            const SizedBox(height: 8),
            InkWell(
              onTap: () {
                launchAdUrl(widget.adsModel.previewShareableLink ?? "");
              },
              child: _buildDetailRow(
                'Preview Shareable Link : ',
                widget.adsModel.previewShareableLink,
                colors: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreativeDetails() {
    return widget.adsModel.creative != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Creative Details',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow(
                          'Creative ID : ', widget.adsModel.creative?.id),
                      const SizedBox(height: 8),
                      _buildDetailRow(
                          'Creative Name : ', widget.adsModel.creative?.name),
                      const SizedBox(height: 16),
                      if (widget.adsModel.creative?.objectStorySpec != null)
                        _buildObjectStorySpecDetails(
                            widget.adsModel.creative!.objectStorySpec!)
                    ],
                  ),
                ),
              ),
            ],
          )
        : const SizedBox.shrink();
  }

  Widget _buildObjectStorySpecDetails(ObjectStorySpec objectStorySpec) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Object Story Spec Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        _buildDetailRow('Page ID : ', objectStorySpec.pageId),
        const SizedBox(height: 8),
        _buildDetailRow(
            'Instagram Actor ID  : ', objectStorySpec.instagramActorId),
        const SizedBox(height: 16),
        if (objectStorySpec.linkData != null)
          _buildLinkDataDetails(objectStorySpec.linkData!),
      ],
    );
  }

  Widget _buildLinkDataDetails(LinkData linkData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Link Data Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        _buildDetailRow('Link : ', linkData.link),
        const SizedBox(height: 8),
        _buildDetailRow('Attachment Style : ', linkData.attachmentStyle),
        const SizedBox(height: 8),
        _buildDetailRow('Image Hash : ', linkData.imageHash),
        const SizedBox(height: 16),
        if (linkData.callToAction != null)
          _buildCallToActionDetails(linkData.callToAction!),
        const SizedBox(height: 8),
        _buildDetailRow('Message : ', linkData.message),
        const SizedBox(height: 8),
        _buildDetailRow('Name : ', linkData.name),
        const SizedBox(height: 8),
        _buildDetailRow('Description : ', linkData.description),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildCallToActionDetails(CallToAction callToAction) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Call To Action Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        _buildDetailRow('Type : ', callToAction.type),
        const SizedBox(height: 8),
        if (callToAction.value != null)
          _buildDetailRow(
              'Lead Gen Form ID : ', callToAction.value?.leadGenFormId),
      ],
    );
  }

  Widget _buildLeadDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Lead Data',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 8),
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.adsModel.leads != null)
                  for (var lead in widget.adsModel.leads!.data)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        _buildDetailRow('Lead ID : ', lead.id),
                        const SizedBox(height: 8),
                        _buildDetailRow('Created Time : ', lead.createdTime),
                        const SizedBox(height: 16),
                        for (var field in lead.fieldData)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildDetailRow('Question : ', field.name),
                              const SizedBox(height: 4),
                              _buildDetailRow(
                                  'Answer : ', field.values.join(', ')),
                              const SizedBox(height: 8),
                            ],
                          ),
                        const SizedBox(height: 8),
                        const Divider(),
                      ],
                    ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String? value, {Color? colors}) {
    return RichText(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.black,
          fontSize: 14,
        ),
        children: [
          TextSpan(
            text: value ?? 'N/A',
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 14,
              color: colors ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Future<String?> _getImageUrlFromHash(String imageHash) async {
    final imageUrlUrl = Uri.parse(
        '$adAccBaseUrl/adimages?fields=id,permalink_url,hash&hashes=["$imageHash"]');
    final imageUrlResponse = await http
        .get(imageUrlUrl, headers: {'Authorization': 'Bearer $accessToken'});

    if (imageUrlResponse.statusCode == 200) {
      final imageUrlData =
          jsonDecode(imageUrlResponse.body) as Map<String, dynamic>;
      final images = imageUrlData['data'] as List<dynamic>;

      for (var image in images) {
        if (image['hash'] == imageHash) {
          return image['permalink_url'];
        }
      }
    } else {
      print('Error fetching image URL: ${imageUrlResponse.statusCode}');
    }

    return null;
  }
}


// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:just_ghar_facebook_post/core/const.dart';
// import 'package:just_ghar_facebook_post/model/ads_model.dart';
// import 'package:http/http.dart' as http;

// class AdDetailScreen extends StatefulWidget {
//   final AdsModel adsModel;

//   const AdDetailScreen({super.key, required this.adsModel});

//   @override
//   State<AdDetailScreen> createState() => _AdDetailScreenState();
// }

// class _AdDetailScreenState extends State<AdDetailScreen> {
//   String? adImageUrl = "";

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _getImageUrlFromHash(
//         widget.adsModel.creative?.objectStorySpec?.linkData?.imageHash ?? "");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text("Ad Details"),
//         ),
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 FutureBuilder<String?>(
//                   future: _getImageUrlFromHash(widget.adsModel.creative
//                           ?.objectStorySpec?.linkData?.imageHash ??
//                       ""),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const Center(child: CircularProgressIndicator());
//                     } else if (snapshot.hasData) {
//                       final imageUrl = snapshot.data;
//                       return imageUrl != null
//                           ? Card(
//                               child: Image.network(
//                                 imageUrl,
//                                 fit: BoxFit.contain,
//                                 errorBuilder: (context, error, stackTrace) =>
//                                     const Text('Error loading image'),
//                               ),
//                             )
//                           : const SizedBox.shrink();
//                     } else if (snapshot.hasError) {
//                       return Text('Error: ${snapshot.error}');
//                     } else {
//                       return const SizedBox
//                           .shrink(); // Handle other scenarios if needed
//                     }
//                   },
//                 ),
//                 const SizedBox(height: 15),
//                 Card(
//                   elevation: 4,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'ID: ${widget.adsModel.id ?? 'N/A'}',
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Text('Name: ${widget.adsModel.name ?? 'N/A'}'),
//                         const SizedBox(height: 8),
//                         Text('Adset ID: ${widget.adsModel.adsetId ?? 'N/A'}'),
//                         const SizedBox(height: 8),
//                         Text('Status: ${widget.adsModel.status ?? 'N/A'}'),
//                         const SizedBox(height: 8),
//                         Text(
//                             'Preview Shareable Link: ${widget.adsModel.previewShareableLink ?? 'N/A'}'),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 const Text(
//                   'Creative Details',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 18,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 widget.adsModel.creative != null
//                     ? Card(
//                         elevation: 4,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'Creative ID: ${widget.adsModel.creative?.id ?? 'N/A'}',
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 16,
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//                               Text(
//                                   'Creative Name: ${widget.adsModel.creative?.name ?? 'N/A'}'),
//                               const SizedBox(height: 16),
//                               widget.adsModel.creative?.objectStorySpec != null
//                                   ? Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         const Text(
//                                           'Object Story Spec Details',
//                                           style: TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 16,
//                                           ),
//                                         ),
//                                         const SizedBox(height: 8),
//                                         Text(
//                                             'Page ID: ${widget.adsModel.creative?.objectStorySpec?.pageId ?? 'N/A'}'),
//                                         const SizedBox(height: 8),
//                                         Text(
//                                             'Instagram Actor ID: ${widget.adsModel.creative?.objectStorySpec?.instagramActorId ?? 'N/A'}'),
//                                         const SizedBox(height: 16),
//                                         widget
//                                                     .adsModel
//                                                     .creative
//                                                     ?.objectStorySpec
//                                                     ?.linkData !=
//                                                 null
//                                             ? Column(
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 children: [
//                                                   const Text(
//                                                     'Link Data Details',
//                                                     style: TextStyle(
//                                                       fontWeight:
//                                                           FontWeight.bold,
//                                                       fontSize: 16,
//                                                     ),
//                                                   ),
//                                                   const SizedBox(height: 8),
//                                                   Text(
//                                                       'Link: ${widget.adsModel.creative?.objectStorySpec?.linkData?.link ?? 'N/A'}'),
//                                                   const SizedBox(height: 8),
//                                                   Text(
//                                                       'Attachment Style: ${widget.adsModel.creative?.objectStorySpec?.linkData?.attachmentStyle ?? 'N/A'}'),
//                                                   const SizedBox(height: 8),
//                                                   Text(
//                                                       'Image Hash: ${widget.adsModel.creative?.objectStorySpec?.linkData?.imageHash ?? 'N/A'}'),
//                                                   const SizedBox(height: 16),
//                                                   widget
//                                                               .adsModel
//                                                               .creative
//                                                               ?.objectStorySpec
//                                                               ?.linkData
//                                                               ?.callToAction !=
//                                                           null
//                                                       ? Column(
//                                                           crossAxisAlignment:
//                                                               CrossAxisAlignment
//                                                                   .start,
//                                                           children: [
//                                                             const Text(
//                                                               'Call To Action Details',
//                                                               style: TextStyle(
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .bold,
//                                                                 fontSize: 16,
//                                                               ),
//                                                             ),
//                                                             const SizedBox(
//                                                                 height: 8),
//                                                             Text(
//                                                                 'Type: ${widget.adsModel.creative?.objectStorySpec?.linkData?.callToAction?.type ?? 'N/A'}'),
//                                                             widget
//                                                                         .adsModel
//                                                                         .creative
//                                                                         ?.objectStorySpec
//                                                                         ?.linkData
//                                                                         ?.callToAction
//                                                                         ?.value !=
//                                                                     null
//                                                                 ? Text(
//                                                                     'Lead Gen Form ID: ${widget.adsModel.creative?.objectStorySpec?.linkData?.callToAction?.value?.leadGenFormId ?? 'N/A'}')
//                                                                 : const SizedBox
//                                                                     .shrink(),
//                                                           ],
//                                                         )
//                                                       : const SizedBox.shrink(),
//                                                   const SizedBox(height: 8),
//                                                   Text(
//                                                       'Message: ${widget.adsModel.creative?.objectStorySpec?.linkData?.message ?? 'N/A'}'),
//                                                   const SizedBox(height: 8),
//                                                   Text(
//                                                       'Name: ${widget.adsModel.creative?.objectStorySpec?.linkData?.name ?? 'N/A'}'),
//                                                   const SizedBox(height: 8),
//                                                   Text(
//                                                       'Description: ${widget.adsModel.creative?.objectStorySpec?.linkData?.description ?? 'N/A'}'),
//                                                   const SizedBox(height: 16),
//                                                 ],
//                                               )
//                                             : const SizedBox.shrink(),
//                                       ],
//                                     )
//                                   : const SizedBox.shrink(),
//                             ],
//                           ),
//                         ),
//                       )
//                     : const SizedBox.shrink(),
//                 const SizedBox(height: 16),
//                 const Text(
//                   'Lead Details',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 18,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Card(
//                   elevation: 4,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         if (widget.adsModel.leads != null)
//                           for (var lead in widget.adsModel.leads!.data)
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Lead ID: ${lead.id}',
//                                   style: const TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 8),
//                                 Text('Created Time: ${lead.createdTime}'),
//                                 const SizedBox(height: 16),
//                                 for (var field in lead.fieldData)
//                                   Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         'Question: ${field.name}',
//                                         style: const TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                       const SizedBox(height: 4),
//                                       Text(
//                                           'Answer: ${field.values.join(', ')}'),
//                                       const SizedBox(height: 8),
//                                     ],
//                                   ),
//                                 const SizedBox(height: 16),
//                               ],
//                             ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ));
//   }

//   Future<String?> _getImageUrlFromHash(String imageHash) async {
//     // 2. Get Image URL from Hash
//     final imageUrlUrl = Uri.parse(
//         '$adAccBaseUrl/adimages?fields=id,permalink_url,hash&hashes=["$imageHash"]');
//     final imageUrlResponse = await http
//         .get(imageUrlUrl, headers: {'Authorization': 'Bearer $accessToken'});

//     if (imageUrlResponse.statusCode == 200) {
//       final imageUrlData =
//           jsonDecode(imageUrlResponse.body) as Map<String, dynamic>;
//       final images = imageUrlData['data'] as List<dynamic>;

//       // Extract image URL
//       for (var image in images) {
//         if (image['hash'] == imageHash) {
//           return image['permalink_url'];
//         }
//       }
//     } else {
//       print('Error fetching image URL: ${imageUrlResponse.statusCode}');
//     }

//     return null;
//   }
// }



