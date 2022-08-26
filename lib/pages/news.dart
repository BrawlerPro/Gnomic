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
  'assets/jol.jpg',
];
class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset(
          imglore[4].toString(),
          height: MediaQuery
              .of(context)
              .size
              .height,
          width: MediaQuery
              .of(context)
              .size
              .width,
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
            backgroundColor: Colors.yellow,
            title: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.newspaper),
                  Text(
                    'Transport News',
                    style: TextStyle(
                      fontFamily: 'Schyler',
                      fontSize: 22,
                    ),
                  )
                ],
              ),
            ),
          ),
          body: SafeArea(
              child: ListView(
                children: [
                  Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(bottom: 6),
                        height: 230,
                        decoration: BoxDecoration(
                          color: Colors.white,
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
                        child: Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                SizedBox(
                                  width: 250,
                                  child: ListTile(
                                    title: Center(
                                      child: Text(
                                          ' \n В июле в России произвели на 80% машин меньше, чем за аналогичный период прошлого года\n    '),
                                    ),
                                    subtitle: Text(
                                        'В июле с российских автоконвейеров сошло всего 19 тысяч автомобилей. Это на 80,6% меньше, чем годом ранее, сообщает «Автостат»...'),
                                  ),
                                )
                              ],
                            ),
                            Container(
                              width: 140,
                              height: 170,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.lightGreen,
                                  width: 5,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Image.network(
                                  'https://www.transport-news.ru/wp-content/uploads/2022/08/11-10.jpg',
                                  fit: BoxFit.fill),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        ),
      ],
    );
  }
}
