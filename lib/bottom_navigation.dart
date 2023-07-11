import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:fcamera/screens/camera_page.dart';
import 'package:fcamera/screens/dashboard.dart';
import 'package:fcamera/screens/profile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';


class BottomNavigation extends StatefulWidget {
  BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  List screenPages = [
    Dashboard(),
    Camera(
      image: null
    ),
    // VideoPlayers(video: null),
    const Profiles()
  ];
  int _selectedIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        index: _selectedIndex,
        items: [
          const Icon(
            Icons.dashboard,
            size: 30,
          ),
          IconButton(
            onPressed: () async {
              ImagePicker imagePicker = ImagePicker();
              XFile? image =
                  await imagePicker.pickImage(source: ImageSource.camera);
              print(image!.path);

              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Camera(
                          image: image,
                        )),
              );
            },
            icon: const Icon(Icons.camera),
          ),
          // IconButton(
          //   onPressed: () async {
          //     ImagePicker imagePicker = ImagePicker();
          //     XFile? video =
          //         await imagePicker.pickVideo(source: ImageSource.camera);
          //     print(video!.path);

          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //           builder: (context) => VideoPlayers(
          //                 video: video,
          //               )),
          //     );
          //   },
          //   icon: const Icon(Icons.videocam),
          // ),
          const Icon(
            Icons.person,
            size: 30,
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      // extendBody: true,
      body: screenPages[_selectedIndex],
    );
  }
}
