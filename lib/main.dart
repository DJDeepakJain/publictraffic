import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_application/bottom_navigation.dart';
import 'package:login_application/register_user.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const Login(),
    );
  }
}class Login extends StatefulWidget {
  const Login({super.key,});



  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {


  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    var nameController = TextEditingController();
    var pswdController = TextEditingController();

    return Scaffold(
        appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    title: const Text('Login'),
    ),
    body: Form(
    key: formKey,
    child: Center(
    child: SizedBox(
    width: 300,
    child: Center(
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
    Image.asset('assets/images/person_icon.png'),const SizedBox(height: 44),
    TextFormField(
    controller: nameController,
    // key: ValueKey(username),
    decoration: InputDecoration(
    prefixIcon: const Icon(Icons.mail),
    label: const Text('Email'),
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(16)
    )
    ),
    validator: (value) {
    if (value!.isEmpty) {
    return 'Please Enter username';
    } else {
    return null;
    }
    },
    onSaved: (value) {
    },
    ),const SizedBox(height: 11),
    TextFormField(
    controller: pswdController,
    //     key: ValueKey(pswd),
    decoration: InputDecoration(
    prefixIcon: const Icon(Icons.key),
    label: const Text('Password'),
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(16)
    ),
    ),
    validator: (value) {
    if (value!.isEmpty) {
    return 'Please Enter password';
    } else {


      return null;
                      }
                    },
                    onSaved: (value) {
                    },
                    obscureText: true,
                    obscuringCharacter: '*',
                  ),const SizedBox(height: 11),
                  ElevatedButton(onPressed: () async {
                    if(formKey.currentState!.validate()){
                      formKey.currentState!.save();

                      buildShowDialog(context);
                      final emailMobile = nameController.text.toString();
                      final password = pswdController.text.toString();

                      signInUser(context: context,
                          emailMobile: emailMobile,
                          password: password);
                    }

  //                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(nameController.text.toString())));
                  },style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blueAccent)), child: const Text('Login')),
                  const SizedBox(height: 22),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text('Don\'t have a account ? ', style: TextStyle(color: Colors.black),),
                        InkWell(
                            onTap:() {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterUser()));
                            },
                            child: const Text('Register', style: TextStyle(color: Colors.blueAccent,decoration: TextDecoration.underline),)),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),);
  }

  Future<void> signInUser({required BuildContext context, required String emailMobile, required String password}) async {

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailMobile, password: password);
      Navigator.pop(context);
      var snackBar = const SnackBar(content: Text('Signed in Successfully'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      Navigator.push(context, MaterialPageRoute(builder: (context) => const BottomNavigation()));
    } on FirebaseAuthException {
      Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No user Found with this Email')));
          }

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
}
