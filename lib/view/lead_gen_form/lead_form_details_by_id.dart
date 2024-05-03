import 'package:flutter/material.dart';
import 'package:just_ghar_facebook_post/model/lead_form_list_model.dart';

class LeadFormDetailScreen extends StatefulWidget {
  final List<LeadsDatum> leadsfieldData;
  const LeadFormDetailScreen({super.key, required this.leadsfieldData});

  @override
  State<LeadFormDetailScreen> createState() => _LeadFormDetailScreenState();
}

class _LeadFormDetailScreenState extends State<LeadFormDetailScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lead Gen Data'),
      ),
      body: ListView.builder(
        itemCount: widget.leadsfieldData.length,
        itemBuilder: (context, index) {
          final leadsDatum = widget.leadsfieldData[index];
          return Padding(
            padding: const EdgeInsets.only(left: 20, right: 10, top: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Created Time: ${leadsDatum.createdTime ?? 'N/A'}'),
                const SizedBox(height: 8),
                ...leadsDatum.fieldData.map(
                  (fieldDatum) => QuestionAnswerWidget(
                    question: fieldDatum.name ?? 'N/A',
                    answers: fieldDatum.values,
                  ),
                ),
                const Divider(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class QuestionAnswerWidget extends StatelessWidget {
  final String question;
  final List<String> answers;

  const QuestionAnswerWidget({
    super.key,
    required this.question,
    required this.answers,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        ...answers.map(
          (answer) => Text(answer),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
