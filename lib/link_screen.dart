import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LinkScreen extends StatefulWidget {
  const LinkScreen({super.key});

  @override
  State<LinkScreen> createState() => _LinkScreenState();
}

class _LinkScreenState extends State<LinkScreen> {
  TextEditingController controller = TextEditingController();
  void addLink() {
    try {
      CollectionReference link = FirebaseFirestore.instance.collection('links');
      Map<String, dynamic> linkValue = {
        'link': controller.text,
      };
      link.add(linkValue).then((value) {
        controller.clear();
        final snackBar = SnackBar(
          content: Text('Success'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    } catch (e) {
      final snackBar = SnackBar(
        content: Text('Error'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter link',
                    isDense: true, // Added this
                    contentPadding: EdgeInsets.all(8), // Added this
                  ),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              InkWell(onTap: _pasteData, child: const Icon(Icons.paste))
            ],
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        SizedBox(
            width: double.infinity,
            child: ElevatedButton(onPressed: addLink, child: Text("Add")))
      ],
    );
  }

  void _pasteData() async {
    ClipboardData? data = await Clipboard.getData('text/plain');
    if (data != null) {
      print("data.text ${data.text}");
      setState(() {
        controller.text = data.text ?? '';
      });
    }
  }
}
