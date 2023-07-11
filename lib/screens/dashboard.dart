// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fcamera/screens/item_detail.dart';

class Dashboard extends StatelessWidget {
  Dashboard({super.key}) {
    _stream = _reference.snapshots();
  }
  final CollectionReference _reference =
      FirebaseFirestore.instance.collection('photos');
  late Stream<QuerySnapshot> _stream;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Dashboard"),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _stream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Has Some Error${snapshot.error}'));
            }
            if (snapshot.hasData) {
              QuerySnapshot querySnapshot = snapshot.data;
              List<QueryDocumentSnapshot> documents = querySnapshot.docs;
              List<Map> info = documents
                  .map((e) => {
                        'id': e.id,
                        'Title': e['Title'],
                        'Desc': e['Desc'],
                        'Date': e['Date'],
                        'Photos': e['Photos'],
                        'Reward': e['Reward'],
                        'Latitude':e['Latitude'],
                        'Longitude':e['Longitude']
                        
                      })
                  .toList();

              return ListView.builder(
                  itemCount: info.length,
                  itemBuilder: (BuildContext context, int index) {
                    Map thisItem = info[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            isThreeLine: true,
                            leading: CircleAvatar(
                              backgroundColor: Colors.amber,
                              backgroundImage:
                                  NetworkImage('${thisItem['Photos']}'),
                            ),
                            title: Text('${thisItem['Title']}'),
                            subtitle: Text('${thisItem['Desc']}'),
                            trailing: Text('${thisItem['Reward']}'),

                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      ItemDetail(thisItem['id'])));
                            },
                          ),
                        ),
                      ),
                    );
                  });
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}
