// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart';
import '../model/data.dart';
import 'item_detail.dart';



class Dashboard extends StatelessWidget {
  Dashboard({super.key}) {
  }

  Map<String, dynamic> infoList = {};

  Future fetchData() async {
    final uri = Uri.parse(
        "https://hostel.abhosting.co.in/smart_school_src/Public_trafic/getVehicle");
    final response = await http.post(uri);

    if (response.statusCode == 200) {
      infoList = jsonDecode(response.body);
      print(infoList['data']);
      print(infoList['data'][0]['image']);
      print(infoList.values.last);
      print(infoList["data"].length);
      return infoList;
    } else {
      throw Exception("Failed to load");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Dashboard"),
        ),
        body:FutureBuilder(
          future: fetchData(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Snapshot has some error ${snapshot.error}"),
              );
            }
    if (snapshot.hasData) {
      return ListView.builder(
          itemCount: infoList['data'].length,
          itemBuilder: (context,index){
            print(index);
            return Container(
              child: Column(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.amber,
                          backgroundImage:
                          NetworkImage('${infoList['data'][index]['image']}'),
                        ),
                        title: Text('${infoList['data'][index]['vehicleNo']}'),
                        subtitle: Text('${infoList['data'][index]['violation']}') ,
                        trailing: Text('${infoList['data'][index]['reward_amount']}'),
    onTap: () {
    Navigator.of(context).push(MaterialPageRoute(
    builder: (context) =>
    ItemDetail(0)));
    },
                      ),
                                          ),
                  )
                ],
              ),
            );
          }
      );
    }
        return Container();
          },

        )
       );
  }
}