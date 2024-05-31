import 'package:flutter/material.dart';
import 'package:scan_barcode/firebase_options.dart';
import 'package:scan_barcode/link_screen.dart';
import 'package:scan_barcode/widgets/links.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: false,
        primarySwatch: Colors.blue,

        // scaffoldBackgroundColor: const Color(0xffefeff4),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isScannerScreen = true;
  String result = '';
  @override
  Widget build(BuildContext context) {
    final widthScreen = MediaQuery.of(context).size.width - 2;
    return Scaffold(
      bottomNavigationBar: SizedBox(
        width: double.infinity,
        child: Row(
          children: [
            SizedBox(
              width: widthScreen / 2,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    isScannerScreen = true;
                  });
                },
                style: ElevatedButton.styleFrom(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(0), // Adjust the radius here
                  ),
                ),
                child: const Text("Scanner"),
              ),
            ),
            const SizedBox(
              width: 2,
            ),
            SizedBox(
              width: widthScreen / 2,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    isScannerScreen = false;
                  });
                },
                style: ElevatedButton.styleFrom(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(0), // Adjust the radius here
                  ),
                ),
                child: const Text("Links"),
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: isScannerScreen
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          var res = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const SimpleBarcodeScannerPage(),
                              ));
                          setState(() {
                            if (res is String) {
                              result = res;
                            }
                          });
                        },
                        icon: const Icon(Icons.camera),
                        label: const Text('Open Scanner'),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('Barcode Result: $result'),
                    ),
                    LinksWidget(
                      barcode: result,
                    )
                  ],
                )
              : LinkScreen(),
        ),
      ),
    );
  }
}
