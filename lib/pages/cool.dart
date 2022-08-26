import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'Home.dart';
import 'dart:math' as math;

var count = 0;
List imglore = [
  'assets/das.jpg',
  'assets/ggf.jpg',
  'assets/kl.jpg',
  'assets/wasbii.jpg',
];

class cool extends StatefulWidget {
  const cool({Key? key}) : super(key: key);

  @override
  _coolState createState() => _coolState();
}

class _coolState extends State<cool> {
  List startapp = [];
  _getCsv() async {
    var url =
        "https://docs.google.com/spreadsheets/d/16Ih3Yl89XXmEA8MDUuRdnEHAKV_AK3cukJn3htrUDs8/edit#gid=1659594966";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  join() async {
    var e = await http.get(Uri.https("script.google.com",
        "macros/s/AKfycbxtmHcYqObFK0E5HfEQSa9CjHi5Af1_sLsfvLYfcWcic0rWrfWeO5dHaWmQvVma58u_lA/exec"));
    startapp = convert.jsonDecode(e.body);
    startapp = convert.jsonDecode(startapp[0][0])[1];
    setState(() {
      if (HOs == true) {
        startapp.sort((b, a) => a['date'].compareTo(b['date']));
      } else {
        startapp.sort((b, a) => a['isTransport'].compareTo(b['isTransport']));
      }
    });
  }

  @override
  void initState() {
    join();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset(
          imglore[1].toString(),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Center(
                  child: Text(
                    'Startups',
                    style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'Schyler'
                    ),
                  ),
                ),
                SizedBox(
                  width: 65,
                )
              ],
            ),
          ),
          body: ListView.builder(
            itemCount: startapp.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 6),
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.cyanAccent,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 1,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(startapp[index]['startup'].toString(), style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17
                    ),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            onPressed: () {
                              launch(startapp[index]['url'].toString());
                            },
                            icon: const Icon(Icons.link))
                      ],
                    ),
                    Text(DateFormat('yyyy-MM-dd')
                        .format(DateTime.fromMillisecondsSinceEpoch(
                        (startapp[index]['date']).toInt()))
                        .toString())
                  ],
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
