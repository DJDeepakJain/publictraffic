import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as https;
import 'login.dart';


class RegisterUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    var fname = TextEditingController();
    var lname = TextEditingController();
    var email_mobile = TextEditingController();
    var password = TextEditingController();

    String email = '';
    String pswd = '';
    String fullname = '';

    return Scaffold(
        appBar: AppBar(title: const Center(
          child: Text(' '),),),
        body:Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                width: 300,
                child:(
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(height: 22),
                        Image.asset('assets/images/person_icon.png'),const SizedBox(height: 22),
                        const Text('Register User',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue)),
                        const SizedBox(height: 44),
                        Row(
                          children:<Widget> [
                            Expanded(
                              child: TextFormField(
                                key: ValueKey(fullname),
                                controller: fname,
                                decoration: InputDecoration(
                                  label: Text('First Name'),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please Enter Full Name';
                                  } else {
                                    return null;
                                  }
                                },
                                onSaved: (value) {
                                  fullname = value!;
                                },
                              ),
                            ),
                            const SizedBox(height: 22,width: 11),
                            Expanded(
                              child: TextField(
                                controller: lname,
                                decoration: InputDecoration(
                                    label: Text('Last Name'),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16))
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),
                        TextFormField(
                          controller: email_mobile,
                          key: ValueKey(email),
                          decoration: InputDecoration(
                            //  prefixIcon: Icon(Icons.phone,Icons.email),
                              label: Text('Mobile Number / Email '),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16))
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please Enter Mobile number/ email';
                            } else {
                              return null;
                            }
                          },
                          onSaved: (value) {
                            email = value!;
                          },
                        ),
                        SizedBox(height: 22),
                        TextFormField(
                          controller: password,
                          key: ValueKey(password),
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.key),
                            label: Text('Password'),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please Enter Password';
                            } else if(value.characters.length<6){
                              return 'At least 6 characters long password required';
                            } else{
                              return null;
                            }
                          }, onSaved: (value) {
                          pswd = value!;
                        },
                          obscureText: true,
                          obscuringCharacter: '*',
                        ),
                        SizedBox(height: 44),
                        ElevatedButton(onPressed: () async {

                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();

                            buildShowDialog(context);

                            final first_name = fname.text.toString();
                            final last_name = lname.text.toString();
                            final emailmobile = email_mobile.text.toString();
                            final pswd = password.text.toString();

                            createUser(context: context,
                                first_name: first_name,
                                last_name: last_name,
                                emailmobile: emailmobile,
                                pswd: pswd);
                          }

                          //       Navigator.pop(context);

                        }, child: Text('Register'),style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue)),
                        ),
                        SizedBox(height: 44),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('Already have a account ?  ', style: TextStyle(color: Colors.black),),
                              InkWell(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                                  },
                                  child: Text('Login', style: TextStyle(color: Colors.blueAccent,decoration: TextDecoration.underline),)),
                            ],
                          ),
                        )
                      ],
                    )
                ),
              ),
            ),
          ),
        )
    );}

  Future createUser({required BuildContext context ,required String first_name, required String last_name, required String emailmobile, required String pswd}) async
  {
    try{
      final doc_user = FirebaseFirestore.instance.collection('user').doc();
      // final json={
      //   'name' : first_name,
      //   'last_name' : last_name,
      //   'email/mobile' : emailmobile,
      //   'password' : pswd
      // };

      //await FirestoreServices.saveUser(first_name,last_name,emailmobile,pswd);
      // await FirebaseFirestore.instance
      //     .collection('user')
      //     .doc('id')
      //     .set({
      //   'name' : first_name,
      //   'last_name' : last_name,
      //   'email/mobile' : emailmobile,
      //   'password' : pswd
      // });
      // //  await doc_user.set(json);
      // UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailmobile, password: pswd);
      // String userid = userCredential.user!.uid;
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // prefs.setString('user_uuid', userid);

      var headers = {
        'Content-Type': 'application/json',
      };
      var request = https.Request('POST', Uri.parse('https://rto.sumerudigital.com/rto/Public_trafic/register?Content-Type=application/json'));
      request.body = json.encode({
        "name": "$first_name  $last_name",
        "email": "$emailmobile",
        "password": "$pswd"
      });
      request.headers.addAll(headers);
      https.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        Navigator.pop(context);
        var snackBar = SnackBar(content: Text('User Registered Successfully'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.push(context, MaterialPageRoute(builder: (context)=> Login()));
        print(await response.stream.bytesToString());
      }
      else {
        Navigator.pop(context);
        print(response.reasonPhrase);
      }

    } catch(e){
      Navigator.pop(context);
      var snackBar = SnackBar(content: Text('Some error occured'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
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