import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fcamera/model/data.dart';

// ignore: must_be_immutable
class Preview extends StatelessWidget {
  final XFile file;
  Preview({super.key, required this.file});
  late Info info;
  final TextEditingController _title = TextEditingController();
  final TextEditingController _desc = TextEditingController();
  late String status;
  late String reward;
  bool _scanning=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Preview"),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 250,
              width: 250,
              child: Image.file(File(file.path)),
            ),
            TextField(
                controller: _title,
                decoration: const InputDecoration(label: Text("Enter Title"))),
            TextField(
              controller: _desc,
              decoration:
                  const InputDecoration(label: Text("Enter Description")),
            ),

            ElevatedButton(onPressed: () {}, child: const Text('Upload'))
          ],
        ),
      ),
    );
  }
}
