import 'package:flutter/material.dart';
import 'package:huaweimlapp/ml_body_api.dart';
import 'package:huaweimlapp/ml_image_api.dart';
import 'package:huaweimlapp/ml_language_api.dart';
import 'package:huaweimlapp/ml_text_api.dart';
import 'package:huaweimlapp/scan_kit.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
        ),
        body: Center(
          child: GridView.count(
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            shrinkWrap: true,
            crossAxisCount: 2,
            padding: const EdgeInsets.all(20),
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MlTextApi()));
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(30)),
                  child: const Center(child: Text('Ml Text APIs')),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MlLanguageApi()));
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(30)),
                  child: const Center(child: Text('Ml Language APIs')),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MlImageApi()),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(30)),
                  child: const Center(child: Text('Ml Image APIs')),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MlBodyApi()),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(30)),
                  child: const Center(child: Text('Ml Body APIs')),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ScanKit()),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(30)),
                  child: const Center(child: Text('Scan Kit')),
                ),
              ),
            ],
          ),
        ));
  }
}
