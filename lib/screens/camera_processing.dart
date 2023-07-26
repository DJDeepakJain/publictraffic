import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as https;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:login_application/model/Result.dart';
import 'package:login_application/model/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  // late Future<String> _image;
  String _image = '';
  late String status='Approval Pending';
  late String text;
  late String reward='Processing';
  late double _latitude=0;
  late double _longitude=0;
  String userid='';
  String currentAdress = '';
  String trimmedText='';
  String postalCode = '775788';
  late Position currentPosition;
  String vehicleNo = '';
  String colour = '';
  bool isVisible=false;
  String permanent_address = '';
  String owner_name = '';
  String manufacturer_model = '';
  String permanentAddress = '';
  String ownerName = '';
  String manufacturerModel = '';
  String manufacturer = '';

  final TextEditingController _vehicleNo = TextEditingController();
  TextEditingController ownername = TextEditingController();
  TextEditingController owner_Name = TextEditingController();
  TextEditingController adress = TextEditingController();
  TextEditingController manuModel = TextEditingController();
  TextEditingController bikeColor = TextEditingController();
  late Result vehicleInfo;


  @override
  void initState() {
    // TODO: implement initState
    getImage(ImageSource.camera);
    // getVideo(ImageSource.camera);
    vehicleInfo = Result(ownerName: "",colour: "",permanentAddress: "",manufacturerModel: "",manufacturer: "");
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

  Future<String> imageToBase64(File imageFile) async {
    List<int> imageBytes = await imageFile.readAsBytes();
    String base64Image = base64Encode(imageBytes);
    return base64Image;
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
      permission = await Geolocator.requestPermission();
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
        semanticLabel: _vehicleNo.text = scannedText,
        content: TextField(
          controller: _vehicleNo,
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

  Future<String?> vehicleDetails() async {
    buildShowDialog(context);
    var headers = {
      'X-RapidAPI-Key': 'a71d96ee9cmshf305ca465fcefcbp1e1c58jsnb777bda3e9db',
      'X-RapidAPI-Host': 'vehicle-rc-information.p.rapidapi.com/',
      'Content-Type': 'application/json'
    };
    var request = https.Request('POST', Uri.parse('$vehicleInfoAPI'));

    String trimmedText = trimSpacesBetweenWords(scannedText);
    String finalTrimmedText = removeSpecialCharacters(trimmedText);
    print(trimmedText);

    request.body = json.encode({
      "VehicleNumber": finalTrimmedText
    });

    request.headers.addAll(headers);
    https.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      Navigator.pop(context);
      isVisible = true;
      final  body1 = (await response.stream.bytesToString()) ;
      dynamic jsonData = jsonDecode(body1);
      print(scannedText);
      request.headers.addAll(headers);
      setState(() {

      });
      vehicleInfo.colour = jsonData['result']['colour'];
      vehicleInfo.permanentAddress = jsonData['result']['permanent_address'];
      vehicleInfo.ownerName = jsonData['result']['owner_name'];
      vehicleInfo.manufacturerModel = jsonData['result']['manufacturer_model'];
      vehicleInfo.manufacturer = jsonData['result']['manufacturer'];
    }
    else {
      Navigator.pop(context);
      var snackBar = const SnackBar(content: Text('Too many requests'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      print(response.reasonPhrase);
    }
    return null;

  }

  String selectedValue='Select type of voilation';
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Plate detector'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if(scanning) const CircularProgressIndicator(),
            if(!scanning && image == null)
              const CircularProgressIndicator(),
            if(image != null)
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  IconButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const Camera()));
                  }, icon: const Icon(Icons.refresh_outlined)),
                  Container(
                  padding: const EdgeInsets.all(20.0),
                  height: 350,
                  width: 350,
                  child: Center
                    (child: SizedBox(
                      child: Image.file(File(image!.path))
                  )
                  ),
                ),
              ]),
            // ElevatedButton(
            //   onPressed: () => getImage(ImageSource.gallery),
            //   child: const Text('Pick an Image'),
            // ),
            const SizedBox(height: 20,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 50,vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Vehicle No: ",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
                  Expanded(child: Text("$scannedText")),
                  IconButton(
                      onPressed: (){
                        openDialog();
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
            ElevatedButton(onPressed: vehicleDetails, child: Text("Check vehicle details",style: TextStyle(color: Colors.white),),style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.deepOrange),)),
            const SizedBox(height: 20,),
            if (isVisible) Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(4),
              width: 300,
              child: Visibility(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child:  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          const Text('Owner Name: ', style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: Colors.black),
                              maxLines: 2),
                          Text(vehicleInfo.ownerName.toString(),style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Colors.orangeAccent))
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          const Text('Address: ', style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: Colors.black),),
                          Text(vehicleInfo.permanentAddress.toString(), style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Colors.orangeAccent))
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          const Text('Model: ', style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: Colors.black),),
                          Text(vehicleInfo.manufacturerModel.toString(), style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Colors.orangeAccent))
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          const Text('Manufacturer: ', style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: Colors.black),),
                          Text(vehicleInfo.manufacturer.toString(), style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Colors.orangeAccent))
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          const Text('Colour: ', style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: Colors.black),),
                          Text(vehicleInfo.colour.toString(), style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Colors.orangeAccent))
                        ],
                      )

                    ],
                  ),
                ),
              ),
            ) ,
    //        else const  Text("Please check the vehicle number") ,
                  Container(
                  margin: const EdgeInsets.all(9),
                  height: 100,
                  width: 250,
                  child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                  //        labelText: 'Select type of voilation',
                  ),
                  dropdownColor: Colors.white,
                  isExpanded: true,
                  value: selectedValue,
                  icon: const Icon(Icons.arrow_downward),onChanged: (String?  newValue){
                  setState((){
                  selectedValue = newValue!;
                  print(newValue);
                  });
                  },
                  items :<String>[
                  'Select type of voilation',
                  'Triple Riding'
                  'Speeding',
                  'Drunk driving',
                  'Jumping traffic signals',
                  'Wrong-way driving',
                  'Using mobile phones while driving',
                  'Improper overtaking',
                  'Driving without a valid license',
                  'Overloading vehicles',
                  'Not wearing seat belts or helmets',
                  'Violation of lane discipline',
                  'Littering / Throwing garbage out of vehicle',
                  'Driving two-wheeler with more than two passengers',
                  'Driving on footpath',
                  'Driving in one-way',
                  'Rash driving',
                  'Driving a four-wheeler in the night with only one headlight',
                  'Driving in the night with no brake lights',
                  'Driving a two or three-wheeler in the night with no headlight',
                  'Driving without a silencer',
                  'Driving a vehicle emitting excessive pollution and smoke' ]
                      .map<DropdownMenuItem<String>>((String value){
                  return DropdownMenuItem<String>(
                  value : value,
                  child : Text(value));
                  }).toList(),)),

            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 50),
              child: ElevatedButton(
                onPressed: () async {
                  _determinePosition();

                  status = "Approval Pending";
                  reward = "Processing";
                },
                child:TextButton(
                  onPressed: postData,
                  child: Text('Submit',style: TextStyle(color: Colors.white),),
                ),style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green)),
              ),

            //  Text("Number Plate: ${scannedText}",
            //   style: const TextStyle(
            //     fontSize: 16,
            //     fontWeight: FontWeight.bold,
            //   ),
            ),
          ],
        ),
      ),
    );

  }

  String trimSpacesBetweenWords(String input) {
    return input.replaceAll(RegExp(r'\s+'), '');
  }

  buildShowDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  Future<String?> postData() async {
    String imageText = await imageToBase64(imageFile);
    _image = "data:image/png;base64,$imageText";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_uuid', userid);

    buildShowDialog(context);
    String trimmedText = trimSpacesBetweenWords(scannedText);
    String finalTrimmedText = removeSpecialCharacters(trimmedText);
    var request = https.Request('POST', Uri.parse('${publicTrafficAPI}addVehicle'));

    request.body = json.encode({
      "uuid": userid,
      "VehicleNo": finalTrimmedText,
      // "color" : vehicleInfo.colour,
      // "model" : vehicleInfo.manufacturerModel,
      // "manufacturer" : vehicleInfo.manufacturer,
      // "owner_name" : vehicleInfo.ownerName,
      "Date" : DateTime.now().toIso8601String(),
      "Violation" : selectedValue,
      "Latitude" : _latitude,
      "Longitude" : _longitude,
      "Locality": currentAdress,
      'Photos': _image,
      "Address" : vehicleInfo.permanentAddress,
      "PostalCode" : postalCode
    });

    //  request.headers.addAll(headers);
    var streamedResponse = await request.send();
    var response = await https.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      print(response.body);
      Navigator.pop(context);
      var snackBar = const SnackBar(content: Text('Details successfully submitted'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.push(context, MaterialPageRoute(builder: (context)=>Dashboard()));

    }
    else {
      Navigator.pop(context);
      var snackBar = const SnackBar(content: Text('Failed to upload'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      print(response.reasonPhrase);
    }
    return null;
  }

  String removeSpecialCharacters(String trimmedText) {
    final regex = RegExp(r'[^\w\s]', multiLine: true, caseSensitive: false);

    // Use the replaceAll method to replace all occurrences of special characters with an empty string
    return trimmedText.replaceAll(regex, '');
  }


}


