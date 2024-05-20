import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:just_ghar_facebook_post/core/const.dart';
import 'package:http/http.dart' as http;
import 'package:just_ghar_facebook_post/model/lead_form_list_model.dart';
import 'package:just_ghar_facebook_post/view/lead_gen_form/lead_form_details_by_id.dart';
import 'package:just_ghar_facebook_post/widgets/drawer_widget.dart';

class LeadFormListScreen extends StatefulWidget {
  const LeadFormListScreen({super.key});

  @override
  State<LeadFormListScreen> createState() => _LeadFormListScreenState();
}

class _LeadFormListScreenState extends State<LeadFormListScreen> {
  bool isLoading = true;
  List<LeadFormListData> leadFormList = [];

  Future<void> getLeadFormList() async {
    final url = Uri.parse(
        '$baseUrl/$pageId/leadgen_forms?fields=id,name,leads_count,leads,status');
    final headers = {'Authorization': 'Bearer $pageAccessToken'};
    final response = await http.get(url, headers: headers);
    try {
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final leadFormData = LeadFormListModel.fromJson(data).data;

        // log("Data : ${data['data']}");
        setState(() {
          leadFormList = leadFormData;
          isLoading = false;
        });
      } else {
        throw Exception('Error getting lead gen forms: ${response.statusCode}');
      }
    } on Exception catch (error) {
      log('Error getting Form list: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getLeadFormList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: const Text(
          'Lead Gen Form',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      drawer: const DrawerWidget(),
      body: isLoading == true
          ? const Center(child: CircularProgressIndicator(color: Colors.black))
          : ListView.builder(
              itemCount: leadFormList.length,
              itemBuilder: (context, index) {
                final data = leadFormList[index];
                if (data.status == "ACTIVE") {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      onTap: () {
                        if (data.leads != null && data.leads!.data.isNotEmpty) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => LeadFormDetailScreen(
                                leadsfieldData: data.leads!.data,
                              ),
                            ),
                          );
                        } else {
                          // Handle the case when data.leads is null or empty
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('No lead data available'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        }
                      },
                      tileColor: Colors.white,
                      title: Text(data.name ?? 'Null'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("ID : ${data.id}"),
                          Text('count: ${data.leadsCount}'),
                        ],
                      ),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
    );
  }
}
