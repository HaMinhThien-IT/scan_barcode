import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class LinksWidget extends StatefulWidget {
  final String barcode;
  const LinksWidget({required this.barcode, super.key});

  @override
  State<LinksWidget> createState() => _LinksWidgetState();
}

class _LinksWidgetState extends State<LinksWidget> {
  CollectionReference fireStore =
      FirebaseFirestore.instance.collection('links');

  List<String> data = [];
  bool loading = false;
  Future<List<String>> getData() async {
    QuerySnapshot querySnapshot = await fireStore.get();

    final allData = querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();

    return allData
        .where((e) => e['link'] != null)
        .map((e) => e['link'] as String)
        .toList();
  }

  @override
  void initState() {
    setState(() {
      loading = true;
    });
    getData().then((value) {
      setState(() {
        data = value;
      });
    });
    setState(() {
      loading = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: data
                .map((e) => Container(
                      margin: const EdgeInsetsDirectional.only(bottom: 8),
                      child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: InkWell(
                          onTap: () {
                            _launchUrl(e + widget.barcode, context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    e + widget.barcode,
                                    style: const TextStyle(
                                        color: Colors.blue, fontSize: 14),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                InkWell(
                                    onTap: () {
                                      _copyToClipboard(
                                          e + widget.barcode, context);
                                    },
                                    child: const Icon(Icons.copy))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ))
                .toList());
  }
}

void _copyToClipboard(String content, BuildContext context) {
  Clipboard.setData(ClipboardData(text: content));
  final snackBar = SnackBar(
    content: Text('Copied: $content'),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

Future<void> _launchUrl(String url, BuildContext context) async {
  final snackBar = SnackBar(
    content: Text('Redirect to: $url'),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
  final Uri _url = Uri.parse(url);
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}
