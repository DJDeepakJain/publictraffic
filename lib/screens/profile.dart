import 'package:flutter/material.dart';
import 'package:login_application/screens/rewards.dart';

class Profiles extends StatelessWidget {
  const Profiles({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 200,
              width: 200,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  // onTap: () {},
                  child: const CircleAvatar(
                    // borderRadius: BorderRadius.circular(100),
                    backgroundImage: NetworkImage(
                        "https://imgv3.fotor.com/images/blog-cover-image/10-profile-picture-ideas-to-make-you-stand-out.jpg"),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Divider(),
            const ProfilePage(
              icon: Icons.person,
              title: 'Name',
              trailing: 'John Steve',

            ),
            const Divider(),
            const ProfilePage(
              icon: Icons.mail_rounded,
              title: 'Email',
              trailing: 'johnsteve@mail.com',
            ),
            const Divider(),
            const ProfilePage(
              icon: Icons.phone_android,
              title: 'Phone',
              trailing: '+919876543210',

            ),
            const Divider(),
            InkWell(
              onTap:(){
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyRewards()),
            );
            },
              child: const ProfilePage(
                icon: Icons.currency_exchange,
                title: 'Rewards',
                trailing: '',
                icons: Icons.arrow_forward_ios_outlined,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {


  const ProfilePage({
    super.key,
    required this.title,
    required this.trailing,
    required this.icon,
    this.icons
  });
  final String title;
  final String trailing;
  final IconData icon;
  final IconData? icons;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: ListTile(
        leading: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
          child: Icon(icon),
        ),
        title: Text(title),
        trailing: Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child:
          trailing.isEmpty ? Icon(icons):
          Text(
            trailing,
          ),
        ),
      ),
    );
  }
}
