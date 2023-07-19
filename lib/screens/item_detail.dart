// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// // ignore: must_be_immutable
// class ItemDetail extends StatelessWidget {
//   ItemDetail(this.itemId, {super.key}) {
//     _reference = FirebaseFirestore.instance.collection('photos').doc(itemId);
//     _futureData = _reference.get();
//   }
//
//   final String itemId;
//   late DocumentReference _reference;
//   late Future<DocumentSnapshot> _futureData;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Details"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(15.0),
//         child: SingleChildScrollView(
//           child: FutureBuilder(
//               future: _futureData,
//               builder: (BuildContext context, AsyncSnapshot snapshot) {
//                 if (snapshot.hasError) {
//                   return Center(
//                     child: Text("Snapshot has some error ${snapshot.error}"),
//                   );
//                 }
//                 if (snapshot.hasData) {
//                   DocumentSnapshot documentSnapshot = snapshot.data;
//                   Map data = documentSnapshot.data() as Map;
//
//                   return (Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       if (data['Photos'] != null)
//                         Padding(
//                           padding: const EdgeInsets.all(20.0),
//                           child: Center(
//                             child: SizedBox(
//                                 height: 300,
//                                 width: 300,
//                                 child: Image.network(data['Photos'])),
//                           ),
//                         ),
//                       const SizedBox(
//                         height: 50,
//                       ),
//                       Row(
//                         children: [
//                           Icon(Icons.electric_bike_outlined),
//                           Text(
//                             " Vehicle Info ",
//                             style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w600),
//                           ),
//                           Icon(Icons.car_crash_outlined)
//                         ],
//                       ),
//
//                       Row(
//                         children: [
//                           Text(" Vehicle No. ",
//                             style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
//                           Text("${data['Vehicle No.']}",
//                             style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w600),)
//                         ],
//                       ),
//
//                       Row(
//                         children: [
//                           Text(
//                             "Violation: ",
//                             style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w600),
//                           ),
//                           Text(
//                             " ${data['Violation']}",
//                             style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w300),
//                           ),
//                         ],
//                       ),
//                       Divider(
//                         thickness: 1,
//                         indent: 10,
//                         color: Colors.grey,
//                       ),
//
//                       const SizedBox(
//                         height: 20,
//                       ),
//
//                       Text('Current Status : ',style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
//
//                       const SizedBox(
//                         height: 10,
//                       ),
//
//                       Row(
//                         children: [
//                           Text(
//                             'Status: ',
//                             style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w600),
//                           ),
//                           Text(
//                             '${data['Status']}',
//                             style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w300),
//                           ),
//                         ],
//                       ),
//                       Divider(
//                         thickness: 1,
//                         indent: 10,
//                         color: Colors.grey,
//                       ),
//                       Row(
//                         children: [
//                           Text(
//                             'Reward: ',
//                             style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w600),
//                           ),
//                           Text(
//                             '${data['Reward']}',
//                             style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w300),
//                           ),
//                         ],
//                       ),
//                       Divider(
//                         thickness: 1,
//                         indent: 10,
//                         color: Colors.grey,
//                       ),
//                       const SizedBox(height: 20,),
//                       Row(
//                         children: [
//                           Icon(Icons.location_on_outlined),
//                           Text("Location",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           Text(
//                             'Address: ',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300),
//                           ),
//                           Text(
//                               '${data['Locality']}'
//                           ),
//
//                           Text(
//                               '${data['PostalCode']}'
//                           ),
//                         ],
//                       ),
//                       Divider(
//                         thickness: 1,
//                         indent: 10,
//                         color: Colors.grey,
//                       ),
//                       Row(
//                         children: [
//                           Text(
//                             'Latitude: ',
//                             style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w300),
//                           ),
//                           Text(
//                             '${data['Latitude']}',
//                             style: const TextStyle(fontSize: 16),
//                           ),
//                         ],
//                       ),
//                       Divider(
//                         thickness: 1,
//                         indent: 10,
//                         color: Colors.grey,
//                       ),
//                       Row(
//                         children: [
//                           Text(
//                             'Longitude: ',
//                             style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w300),
//                           ),
//                           Text(
//                             '${data['Longitude']}',
//                             style: const TextStyle(fontSize: 16),
//                           ),
//                         ],
//                       ),
//                       Divider(
//                         thickness: 1,
//                         indent: 10,
//                         color: Colors.grey,
//                       ),
//                       SizedBox(height: 20,)
//                     ],
//                   ));
//                 }
//
//                 return const Center(
//                   child: CircularProgressIndicator(),
//                 );
//               }),
//         ),
//       ),
//     );
//   }
// }
