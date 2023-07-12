import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../model/data.dart';
import 'dashboard.dart';

class Camera extends StatefulWidget {
  final XFile? image;
  const Camera({super.key, this.image,});

  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  XFile? image;
  final picker = ImagePicker();
  late File imageFile;
  img.Image binaryImage = img.Image(width:1, height:1); // Set initial size to avoid null
  String scannedText = '';
  bool scanning = false;
  String? _image;
  late String status;
  late String text;
  late String reward;
  late double _latitude;
  late double _longitude;
  String currentAdress = '';
  String postalCode = '';
  late Position currentPosition;
  
  final TextEditingController _vehicleNo = TextEditingController();
  final TextEditingController _violation = TextEditingController();


  final CollectionReference _reference =
  FirebaseFirestore.instance.collection('photos');

  late Info info;

  @override
  void initState() {
    // TODO: implement initState
    getImage(ImageSource.camera);
    info = Info(vehicleNo: "", date: DateTime.now(), violation: "", photos: "");

    super.initState();
  }

  void getImage(ImageSource source) async {
    XFile? pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      scanning = true;
      image = pickedFile;
      setState(() {
        imageFile = File(pickedFile.path);
        binaryImage = img.Image(width: 1,
            height: 1); // Reset binaryImage when new image is selected

      });
      binarizeImage();
    }
  }

  void binarizeImage() async{

    img.Image? image = img.decodeImage(imageFile.readAsBytesSync());
    img.Image grayscaleImage = img.grayscale(image!);
    binaryImage = threshold(grayscaleImage, 128);

    // Label the binary image
    // img.Image ximage = binaryImage; // Your img.Image object
    XFile? xFile = convertImageToXFile(image);
    getRecognizedText(xFile!);

    setState(() {});
  }

  XFile? convertImageToXFile(img.Image image) {
    final tempDir = Directory.systemTemp;
    final tempPath = tempDir.path;
    final tempFilePath = '$tempPath/temp_image.png';

    File(tempFilePath).writeAsBytesSync(img.encodePng(image));

    return XFile(tempFilePath);
  }

  void getRecognizedText(XFile image) async{
    final inputImage = InputImage.fromFilePath(image.path);
    final textDetector = GoogleMlKit.vision.textRecognizer();
    RecognizedText recognizedText = await textDetector.processImage(inputImage);
    await textDetector.close();
    scannedText = '';
    for(TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        scannedText = scannedText + line.text;
      }
    }
    scanning = false;

    setState(() {

    });

  }

  img.Image threshold(img.Image image, int thresholdValue) {
    img.Image binaryImage = img.Image(width:image.width, height:image.height);

    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        img.Color color = image.getPixel(x, y);
        num gray = img.getLuminance(color);

        if (gray < thresholdValue) {
          binaryImage.setPixel(x, y, img.ColorFloat32.rgb(0, 0, 0));
        } else {
          binaryImage.setPixel(x, y, img.ColorFloat32.rgb(255, 255, 255));
        }
      }
    }

    return binaryImage;
  }


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
        _latitude = position.latitude;
        _longitude = position.longitude;

      });
    }
    catch(e){
      print(e);
    }
    return position;
  }

  openDialog()=> showDialog<String>(
      context: context,
      builder: (context)=> AlertDialog(
        content: TextField(
          controller: _vehicleNo,
          decoration: InputDecoration(labelText: scannedText),
        ),
        actions: [
          TextButton(onPressed:
          submit, child: const Text("Submit"))
        ],
      )
  );
  submit(){
    Navigator.of(context).pop(_vehicleNo.text);
    setState(() {
      scannedText = _vehicleNo.text;
    });
    _vehicleNo.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number PLate detector'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if(scanning) const CircularProgressIndicator(),
            if(!scanning && image == null)
              const Padding(
                padding: EdgeInsets.all(10.0),

                child: Center(
                  child:  CircularProgressIndicator(),
                ),
              ),
            if(image != null)
              Center(child: SizedBox(height: 350,width: 350, child: Image.file(File(image!.path))
              )
              ),


            // ElevatedButton(
            //   onPressed: () => getImage(ImageSource.gallery),
            //   child: const Text('Pick an Image'),
            // ),
        const SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Text("Vehicle No:  $scannedText"),
                  IconButton(
                      onPressed: (){
                        final text = openDialog();
                        setState(() {
                          scannedText;
                        });
                      },
                      icon:const Icon(Icons.edit)
                  )
                ],
              ),
            ),
            const SizedBox(height: 20,),
            TextField(
              controller: _violation,
              decoration:
              const InputDecoration(label: Text("Enter Description")),
            ),

            ElevatedButton(
                onPressed: () async {
                  _determinePosition();
                  String uniqueName =
                  DateTime.now().millisecondsSinceEpoch.toString();
                  Reference ref = FirebaseStorage.instance.ref();
                  Reference image = ref.child(uniqueName);
                  await image.putFile(File(widget.image!.path));
                  await image.putFile(imageFile);
                  _image = await image.getDownloadURL();
                  info.vehicleNo = scannedText;
                  info.violation = _violation.text;
                  info.date = DateTime.now();
                  status = "Approval Pending";
                  reward = "Processing";


                  Map<String, dynamic> dataToSend = {
                    'VehicleNo': info.vehicleNo,
                    'Violation': info.violation,
                    'Date': info.date,
                    'Photos': _image,
                    'Status': status,
                    'Reward': reward,
                    'Locality': currentAdress,
                    'PostalCode':postalCode,
                    'Latitude':_latitude,
                    'Longitude':_longitude




                  };

                  _reference.add(dataToSend);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Dashboard()));
                },
                child: const Text('Upload')),



            //  Text("Number Plate: ${scannedText}",
            //   style: const TextStyle(
            //     fontSize: 16,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
