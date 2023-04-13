
import 'package:flutter/material.dart';
import 'package:testai/main.dart';
import 'package:testai/models/airport.dart';
import 'package:testai/services/airports_service.dart';

class Fleet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Fleet();
  }
}

class _Fleet extends State<Fleet> {
  List<Airport> airports = [];

  final europeanCountries = ['A320', 'A321', 'A330', 'A350', 'A380', 'B737', 'B747', 'B757', 'B767', 'B777', 'B787', 'E190'];

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() async {
    final a = AirportsService();
    final air = await a.all();

    setState(() {
      airports = air;
    });
  }  
 
  @override
  Widget build(BuildContext context) {
    return Expanded(child:
      ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
        itemCount: airports.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(airports[index].name),
          );
        },
      )
    );
  }
}