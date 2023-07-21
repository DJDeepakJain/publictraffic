import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
  static saveUser(String first_name,last_name,email,pasword) async{
    await FirebaseFirestore.instance
                           .collection('user')
                           .doc()
                           .set({
                                  'name' : first_name,
                                  'last_name' : last_name,
                                  'email/mobile' : email,
                                  'password' : pasword
                                });
  }
}