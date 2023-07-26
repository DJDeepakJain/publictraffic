import 'package:flutter/material.dart';

class MyRewards extends StatefulWidget {
  const MyRewards({super.key});

  @override
  State<MyRewards> createState() => _MyRewardsState();
}

class _MyRewardsState extends State<MyRewards> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text('My Rewards'),
    ),
    body: Card(
      elevation: 5,
      color: Colors.white70,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16,16,4,4),
        padding: const EdgeInsets.all(4),
        height: 150,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text('Type of Voilation -', style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: Colors.black),
                maxLines: 2),
                Expanded(
                  child: Text('Without helmet riding with bike',overflow: TextOverflow.ellipsis,maxLines: 2,
                      style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Colors.orangeAccent)),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Text('Date -', style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: Colors.black),),
                Text('13 July 1623', style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Colors.orangeAccent))
              ],
            ),
            Row(
              children: <Widget>[
                Text('Reward received -', style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: Colors.black),),
                Text('Yes', style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Colors.orangeAccent))
              ],
            ),
            Row(
              children: <Widget>[
                Text('Reward Amount -', style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: Colors.black),),
                Text('INR 1500', style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Colors.orangeAccent))
              ],
            )
          ],
        ),
      ),
    ),

    );
  }
}

