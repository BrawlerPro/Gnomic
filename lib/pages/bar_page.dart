import 'dart:math';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'model_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:math' as math;
import 'package:zaeb/main.dart';
List imglore = [
  'assets/das.jpg',
  'assets/ggf.jpg',
  'assets/kl.jpg',
  'assets/wasbii.jpg',
  'assets/jol.jpg'
];
class BarPage extends StatefulWidget {
  const BarPage({Key? key}) : super(key: key);

  @override
  _BarPageState createState() => _BarPageState();
}

class _BarPageState extends State<BarPage> {
  final List<BarChartModel> data = [];
  List startapp = [];

  join() async {
    var e = await http.get(Uri.https("script.google.com",
        "macros/s/AKfycbwObvdY_oyLjINPIEwCxWl_xrN7oKogchzBcJQnZz868FPfp2rX3LSD62qEa_zrOijTEw/exec"));
    startapp = convert.jsonDecode(e.body);
    startapp = convert.jsonDecode(startapp[0][0])[0];
    setState(() {
      startapp.sort((b, a) => a['popul'].compareTo(b['popul']));
      for (var i = 0;
          i < (startapp.length.toInt() < 10 ? (startapp.length).toInt() :10);
          i++) {
        data.add(
          BarChartModel(
            year: startapp[i]['startup'],
            financial: startapp[i]['popul'],
            color: charts.ColorUtil.fromDartColor(
                Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                    .withOpacity(1.0)),
          ),
        );
      }
    });
    print(startapp);
  }

  @override
  void initState() {
    join();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<charts.Series<BarChartModel, String>> series = [
      charts.Series(

        id: "financial",
        data: data,
        domainFn: (BarChartModel series, _) => series.year,
        measureFn: (BarChartModel series, _) => series.financial,
        colorFn: (BarChartModel series, _) => series.color,
      ),
    ];

    return Stack(children: <Widget>[
      Image.asset(
        imglore[4].toString(),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
      ),
      Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          title: const Text(
              "Bar Chart Most Famous",
            style: TextStyle(
              fontSize: 25,
              fontFamily: 'Schyler',
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.green[700],
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
          child: charts.BarChart(
            series,
            animate: true,
          ),
        ),
      ),
    ]);
  }
}
