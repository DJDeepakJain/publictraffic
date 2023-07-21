// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'item_detail.dart';



class Dashboard extends StatelessWidget {
  Dashboard({super.key});

  Map<String, dynamic> infoList = {};

  Future fetchData() async {
    final uri = Uri.parse(
        "https://hostel.abhosting.co.in/smart_school_src/Public_trafic/getVehicle");
    final response = await http.post(uri);

    if (response.statusCode == 200) {
      infoList = jsonDecode(response.body);

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
      List documents = infoList['data'];
      List<Map> info = documents.map((e) =>
      {
        'id': e['id'],
        'VehicleNo':e['vehicleNo'],
        'Violation':e['violation'],
        'Photos':e['image'],
        'Reward': e['reward_amount'],
        'Locality': e['locality'],
        'PostalCode': e['postalCode'],
        'Latitude':e['latitude'],
        'Longitude':e['longitude']
      }
      ).toList();
      return ListView.builder(
          itemCount: info.length,
          itemBuilder: (context,index){
            Map thisItem = info[index];
            return Column(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.amber,
                        backgroundImage:
                        NetworkImage('${thisItem['Photos']}'),
                      ),
                        title: Text('${thisItem['VehicleNo']}'),
                        subtitle: Text('${thisItem['Violation']}'),
                        trailing: Text('${thisItem['Reward']}'),

                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  ItemDetail(thisItem['id'])));
                        },
                    ),
                                        ),
                )
              ],
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