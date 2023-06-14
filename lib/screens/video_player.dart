// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:fcamera/model/data.dart';
// import 'package:fcamera/screens/dashboard.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:video_player/video_player.dart';

// class VideoPlayers extends StatefulWidget {
//   XFile? video;
//   VideoPlayers({super.key, required this.video});

//   @override
//   _VideoPlayersState createState() => _VideoPlayersState();
// }

// class _VideoPlayersState extends State<VideoPlayer> {
//   final CollectionReference _reference =
//       FirebaseFirestore.instance.collection('photos');
//   late Info info;
//   final TextEditingController _title = TextEditingController();

//   final TextEditingController _desc = TextEditingController();
//   String? _video;
//   late String status;

//   late String reward;

//   @override
//   void initState() {
//     super.initState();
//     info = Info(title: "", date: DateTime.now(), desc: "", photos: "");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text("Camera"),
//         ),
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               children: [
//                 Center(
//                   child: SizedBox(
//                     height: 250,
//                     width: 250,
//                     child: Image.file(File(widget.video!.path)),
//                   ),
//                 ),
//                 TextField(
//                     controller: _title,
//                     decoration:
//                         const InputDecoration(label: Text("Enter Title"))),
//                 TextField(
//                   controller: _desc,
//                   decoration:
//                       const InputDecoration(label: Text("Enter Description")),
//                 ),
//                 ElevatedButton(
//                     onPressed: () async {
//                       String uniqueName =
//                           DateTime.now().millisecondsSinceEpoch.toString();
//                       Reference ref = FirebaseStorage.instance.ref();
//                       Reference image = ref.child(uniqueName);

//                       await image.putFile(File(widget.video!.path));
//                       _video = await image.getDownloadURL();
//                       info.title = _title.text;
//                       info.desc = _desc.text;
//                       info.date = DateTime.now();
//                       status = "Approval Pending";
//                       reward = "Processing";
//                       if (widget.video != null) {
//                         Image.file(File(widget.video!.path));
//                       }

//                       Map<String, dynamic> dataToSend = {
//                         'Title': info.title,
//                         'Desc': info.desc,
//                         'Date': info.date,
//                         'Photos': _video,
//                         'Status': status,
//                         'Reward': reward,
//                       };

//                       _reference.add(dataToSend);
//                       // ignore: use_build_context_synchronously
//                       Navigator.push(context,
//                           MaterialPageRoute(builder: (context) => Dashboard()));
//                     },
//                     child: const Text('Upload'))
//               ],
//             ),
//           ),
//         )

//         // // FloatingActionButton(onPressed: clickPhoto()),

//         // ],
//         );
//   }
// }
