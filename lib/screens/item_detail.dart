import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class ItemDetail extends StatelessWidget {
  int ind;
  ItemDetail(this.ind, {super.key}) {

  }
  Map<String, dynamic> infoList = {};
  Future fetchData() async {
    final uri = Uri.parse(
        "https://hostel.abhosting.co.in/smart_school_src/Public_trafic/getVehicle/ind");
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
        title: const Text("Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: FutureBuilder(

              future: fetchData(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Snapshot has some error ${snapshot.error}"),
                  );
                }
                if (snapshot.hasData) {


                  return (Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (infoList.values.last[ind]['image'] != null)
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Center(
                            child: SizedBox(
                                height: 300,
                                width: 300,
                                child: Image.network(infoList.values.last[ind]['image'])),
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
                            style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w600),
                          ),
                          Icon(Icons.car_crash_outlined)
                        ],
                      ),

                      Row(
                        children: [
                          Text(" Vehicle No. ",
                            style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
                          Text("${infoList.values.last[ind]['vehicleNo']}",
                            style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w600),)
                        ],
                      ),

                      Row(
                        children: [
                          Text(
                            "Violation: ",
                            style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w600),
                          ),
                          Text(
                            " ${infoList.values.last[ind]['violation']}",
                            style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w300),
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

                      Text('Current Status : ',style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),

                      const SizedBox(
                        height: 10,
                      ),

                      Row(
                        children: [
                          Text(
                            'Status: ',
                            style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '${infoList.values.last[ind]['status']}',
                            style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w300),
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
                            style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '${infoList.values.last[ind]['reward_amount']}',
                            style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w300),
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
                          Text("Location",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Address: ',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300),
                          ),
                          Text(
                              '${infoList.values.last[ind]['locality']}'
                          ),

                          Text(
                              '${infoList.values.last[ind]['postalCode']}'
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
                            style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w300),
                          ),
                          Text(
                            '${infoList.values.last[ind]['latitude']}',
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
                            style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w300),
                          ),
                          Text(
                            '${infoList.values.last[ind]['longitude']}',
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

                return const Center(
                  child: CircularProgressIndicator(),
                );
              }),
        ),
      ),
    );
  }
}
