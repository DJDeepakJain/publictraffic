import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ItemDetail extends StatelessWidget {
  ItemDetail(this.itemId, {super.key}) {
    _reference = FirebaseFirestore.instance.collection('photos').doc(itemId);
    _futureData = _reference.get();
  }

  final String itemId;
  late DocumentReference _reference;
  late Future<DocumentSnapshot> _futureData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: FutureBuilder(
              future: _futureData,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Snapshot has some error ${snapshot.error}"),
                  );
                }
                if (snapshot.hasData) {
                  DocumentSnapshot documentSnapshot = snapshot.data;
                  Map data = documentSnapshot.data() as Map;
        
                  return (Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (data['Photos'] != null)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: SizedBox(
                                height: 300,
                                width: 300,
                                child: Image.network(data['Photos'])),
                          ),
                        ),
                      const SizedBox(
                        height: 50,
                      ),
                      Text(
                        "Title: ${data['Title']}",
                        style: const TextStyle(fontSize: 20),
                      ),
                      Text(
                        "Description: ${data['Desc']}",
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Text in image:\n ${data['Text']}",
                        style: const TextStyle(fontSize: 15),
                      ),
                       const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Status: ${data['Status']}',
                        style: const TextStyle(fontSize: 20),
                      ),
                      Text(
                        'Reward: ${data['Reward']}',
                        style: const TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 20,),
                      Text(
                        'Latitude: ${data['Latitude']}',
                        style: const TextStyle(fontSize: 20),
                      ),
                      Text(
                        'Longitude: ${data['Longitude']}',
                        style: const TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 20,)
                    ],
                  ));
                }
        
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }),
        ),
      ),
    );
  }
}
