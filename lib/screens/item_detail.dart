import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class ItemDetail extends StatelessWidget {
  final String ind;
  ItemDetail(this.ind, {super.key}) {

  }

  Map<String, dynamic> infoList = {};
  Future fetchData() async {

    final uri = Uri.parse(
        "https://hostel.abhosting.co.in/smart_school_src/Public_trafic/getVehicle");
    final response = await http.post(uri,body:
    {
      "vehicle_id":ind
    }
    );

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
        title: const Text("Details"),
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
    itemBuilder: (context,index) {
      Map thisItem = info[index];
      return (Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (thisItem['Photos'] != null)
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: SizedBox(
                    height: 300,
                    width: 300,
                    child: Image.network('${thisItem['Photos']}')),
              ),
            ),
          const SizedBox(
            height: 50,
          ),
          Row(
            children: [
              Icon(Icons.electric_bike_outlined),
              Text(
                " Vehicle Info ",
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w600),
              ),
              Icon(Icons.car_crash_outlined)
            ],
          ),

          Row(
            children: [
              Text(" Vehicle No. ",
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w600),),
              Text('${thisItem['VehicleNo']}',
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w600),)
            ],
          ),

          Row(
            children: [
              Text(
                "Violation: ",
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w600),
              ),
              Text(
                " ${thisItem['Violation']}",
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w300),
              ),
            ],
          ),
          Divider(
            thickness: 1,
            indent: 10,
            color: Colors.grey,
          ),

          const SizedBox(
            height: 20,
          ),

          Text('Current Status : ',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),),

          const SizedBox(
            height: 10,
          ),

          Row(
            children: [
              Text(
                'Status: ',
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w600),
              ),
              Text(
                '${thisItem['Status']}',
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w300),
              ),
            ],
          ),
          Divider(
            thickness: 1,
            indent: 10,
            color: Colors.grey,
          ),
          Row(
            children: [
              Text(
                'Reward: ',
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w600),
              ),
              Text(
                '${thisItem['Reward']}',
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w300),
              ),
            ],
          ),
          Divider(
            thickness: 1,
            indent: 10,
            color: Colors.grey,
          ),
          const SizedBox(height: 20,),
          Row(
            children: [
              Icon(Icons.location_on_outlined),
              Text("Location", style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w600),),
            ],
          ),
          Row(
            children: [
              Text(
                'Address: ', style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w300),
              ),
              Text(
                  '${thisItem['Locality']}'
              ),

              Text(
                  '${thisItem['PostalCode']}'
              ),
            ],
          ),
          Divider(
            thickness: 1,
            indent: 10,
            color: Colors.grey,
          ),
          Row(
            children: [
              Text(
                'Latitude: ',
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w300),
              ),
              Text(
                '${thisItem['Latitude']}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          Divider(
            thickness: 1,
            indent: 10,
            color: Colors.grey,
          ),
          Row(
            children: [
              Text(
                'Longitude: ',
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w300),
              ),
              Text(
                '${thisItem['Longitude']}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          Divider(
            thickness: 1,
            indent: 10,
            color: Colors.grey,
          ),
          SizedBox(height: 20,)
        ],
      ));
    }
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}