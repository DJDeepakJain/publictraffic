import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fcamera/model/data.dart';
import 'package:fcamera/screens/dashboard.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

class Camera extends StatefulWidget {
  final XFile? image;
  const Camera({super.key, required this.image});

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  String? _image;
  String currentAdress = '';
  late Position currentPosition;

  final TextEditingController _title = TextEditingController();

  final TextEditingController _desc = TextEditingController();

  late String status;
  late String text;

  late String reward;
  bool _scanning = false;
  String _extractText = '';

Future<Position> _determinePosition() async{
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if(!serviceEnabled){
    Fluttertoast.showToast(msg: 'Please keep your location turned on');
  }

  permission = await Geolocator.checkPermission();
  if(permission == LocationPermission.denied){
    permission =await Geolocator.requestPermission();
  }
  if(permission == LocationPermission.denied){
    Fluttertoast.showToast(msg: 'Location Permission is denied');
  }

  if(permission == LocationPermission.deniedForever){
    Fluttertoast.showToast(msg: "Permission is denied forever");
  }

  Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

  try{
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];
    setState(() {
      currentPosition = position;
      currentAdress = '${place.locality},${place.country}';
    });
  }
  catch(e){
    print(e);
  }
  return position;
}


  final CollectionReference _reference =
      FirebaseFirestore.instance.collection('photos');

  late Info info;
  @override
  void initState() {
    super.initState();
    info = Info(title: "", date: DateTime.now(), desc: "", photos: "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Camera"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding:  EdgeInsets.all(8.0),
            child: Column(
              children: [
                Center(
                  child: SizedBox(
                    height: 250,
                    width: 250,
                    child: Image.file(File(widget.image!.path)),
                  ),
                ),
                TextField(
                    controller: _title,
                    decoration:
                        const InputDecoration(label: Text("Enter Title"))),
                TextField(
                  controller: _desc,
                  decoration:
                      const InputDecoration(label: Text("Enter Description")),

                ),
                

                SizedBox(height: 20,),
                _scanning ? const Center():Text('Text in the Image:\n' + _extractText),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment:MainAxisAlignment.spaceEvenly,

                    children: [
                      ElevatedButton(onPressed: () async{
                         setState(() {
                          _scanning=true;
                        });
                        _extractText = await FlutterTesseractOcr.extractText(widget.image!.path);
                        setState(() {
                          _scanning = false;
                        });
                      }, child: const Text('Scan the text')),
                      ElevatedButton(
                          onPressed: () async {
                            Position position= _determinePosition() as Position;
                            String uniqueName =
                                DateTime.now().millisecondsSinceEpoch.toString();
                            Reference ref = FirebaseStorage.instance.ref();
                            Reference image = ref.child(uniqueName);
                
                            await image.putFile(File(widget.image!.path));
                            _image = await image.getDownloadURL();
                            info.title = _title.text;
                            info.desc = _desc.text;
                            info.date = DateTime.now();
                            status = "Approval Pending";
                            reward = "Processing";
                            text = '';
                            if (widget.image != null) {
                              Image.file(File(widget.image!.path));
                            }
                
                            Map<String, dynamic> dataToSend = {
                              'Title': info.title,
                              'Desc': info.desc,
                              'Date': info.date,
                              'Photos': _image,
                              'Status': status,
                              'Reward': reward,
                              'Text': _extractText,
                              'Latitude':position.latitude,
                              'Longitude':position.longitude


                            };
                
                            _reference.add(dataToSend);
                            // ignore: use_build_context_synchronously
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => Dashboard()));
                          },
                          child: const Text('Upload')),
                    ],
                  ),
                )
              ],
            ),
          ),
        )

        // // FloatingActionButton(onPressed: clickPhoto()),

        // ],
        );
    // );
  }


}



  // clickPhoto() async {
  //   ImagePicker imagePicker = ImagePicker();
  //   XFile? file = await imagePicker.pickImage(source: ImageSource.camera);

  //   // if (file == null) {
  //   //   return;
  //   // }
  //   // String uniqueName = DateTime.now().millisecondsSinceEpoch.toString();
  //   // Reference ref = FirebaseStorage.instance.ref();
  //   // Reference image = ref.child(uniqueName);
  //   // try {
  //   //   await image.putFile(File(file.path));
  //   //   _image = await image.getDownloadURL();
  //   // } catch (error) {
  //   //   print(error);
  //   // }
  // }
  


    
   