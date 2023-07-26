import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login_application/model/constants.dart';

// ignore: must_be_immutable
class ItemDetail extends StatelessWidget {
  final String ind;
  ItemDetail(this.ind, {super.key});

  Map<String, dynamic> infoList = {};
  Future fetchData() async {

    final uri = Uri.parse(
        "${publicTrafficAPI}getVehicle");
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

          // thisItem['Photos'] !="" ?
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: SizedBox(
                    height: 300,
                    width: 300,
                    child: Image.network('$profileImage${thisItem['Photos']}')),
              ),
            ),
          //       : Padding(
          //   padding: const EdgeInsets.all(20.0),
          //   child: Center(
          //     child: Container(
          //         height: 300,
          //         width: 300,
          //       color: Colors.amber,
          //           ),
          //   ),
          // ),
          const SizedBox(
            height: 50,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.electric_bike_outlined),
              Text(
                " Vehicle Info ",
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w600),
              ),
              Icon(Icons.car_crash_outlined)
            ],
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(32, 8, 32, 8),
            child: Row(
              children: [
                const Text(" Vehicle No: ",
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w400),),
                Text('${thisItem['VehicleNo']}',
                  style: const TextStyle(color: Colors.deepOrangeAccent,
                      fontSize: 20, fontWeight: FontWeight.w400),)
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(32, 8, 32, 8),
            child: Row(
              children: [
                const Text(
                  "Violation: ",
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w400),
                ),
                Expanded(
                  child: Text(
                    " ${thisItem['Violation']}",
                    style: const TextStyle(color: Colors.deepOrangeAccent,
                        fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          const Text('Current Status : ',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),),

          const SizedBox(
            height: 10,
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(32, 8, 32, 8),
            child: Row(
              children: [
                const Text(
                  'Status: ',
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600),
                ),
                thisItem['Status'] != 0?
                const Text(
                  'Accepted',
                  style: TextStyle(color: Colors.deepOrangeAccent,
                      fontSize: 16, fontWeight: FontWeight.w300),
                ):
      const Text(
      'Processing',
      style: TextStyle(
      fontSize: 16, fontWeight: FontWeight.w300),
      )
      ],
            ),
          ),
          const Divider(
            thickness: 1,
            indent: 10,
            color: Colors.grey,
          ),
          thisItem['Status'] != 0 && thisItem['Status'] != null?
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 8, 32, 8),
            child: Row(
              children: [
                const Text(
                  'Reward: ',
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600),
                ),
                Text(
                  '${thisItem['Reward']}',
                  style: const TextStyle(color: Colors.deepOrangeAccent,
                      fontSize: 16, fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ):Container(),
          thisItem['Status'] != 0 && thisItem['Status'] != null?
          const Divider(
            thickness: 1,
            indent: 10,
            color: Colors.grey,
          ):Container(),
          const SizedBox(height: 20,),
          const Row(
            children: [
              Icon(Icons.location_on_outlined),
              Text("Location", style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w600),),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 8, 32, 8),
            child: Row(
              children: [
                const Text(
                  'Address: ', style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w300),
                ),
                Text(
                    '${thisItem['Locality']}',style: const TextStyle(color: Colors.deepOrangeAccent,),
                ),

                Text(
                    '${thisItem['PostalCode']}',
                style: const TextStyle(color: Colors.deepOrangeAccent,),

            ),
            ]
          ),
          ),
          const Divider(
            thickness: 1,
            indent: 10,
            color: Colors.grey,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 8, 32, 8),
            child: Row(
              children: [
                const Text(
                  'Latitude: ',
                  style: TextStyle(color: Colors.deepOrangeAccent,
                      fontSize: 16, fontWeight: FontWeight.w300),
                ),
                Text(
                  '${thisItem['Latitude']}',
                  style: const TextStyle(fontSize: 16,color: Colors.deepOrangeAccent,),
                ),
              ],
            ),
          ),
          const Divider(
            thickness: 1,
            indent: 10,
            color: Colors.grey,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 8, 32, 8),
            child: Row(
              children: [
                const Text(
                  'Longitude: ',
                  style: TextStyle(color: Colors.deepOrangeAccent,
                      fontSize: 16, fontWeight: FontWeight.w300),
                ),
                Text(
                  '${thisItem['Longitude']}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          const Divider(
            thickness: 1,
            indent: 10,
            color: Colors.grey,
          ),
          const SizedBox(height: 20,)
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