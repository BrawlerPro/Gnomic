import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zaeb/pages/bar_page.dart';
import 'package:zaeb/pages/news.dart';

import 'idie.dart';
import 'import_to_csv.dart';



bool HOs = false;
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;
  _getCsv() async {
    var url =
        "https://docs.google.com/spreadsheets/d/16Ih3Yl89XXmEA8MDUuRdnEHAKV_AK3cukJn3htrUDs8/edit#gid=1659594966";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      menuScreen: DrawerScreen(
        setIndex: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
      mainScreen: currentScreen(),
      borderRadius: 30,
      showShadow: true,
      angle: 0.0,
      slideWidth: 200,
      menuBackgroundColor: Colors.deepPurple,
    );
  }

  Widget currentScreen() {
    switch (currentIndex) {
      case 0:
        return NewsPage();
      case 1:
        return MM();
      case 2:
        return BarPage();
      case 3:
        return _getCsv();
      case 4:
        return const HomeScreen(
          title: "Import To Csv",
        );
      case 5:
        return Scaffold(
          appBar: AppBar(
            title: const Text('Lmao'),
          ),
        );
      default:
        return const HomeScreen();
    }
  }
}

class HomeScreen extends StatefulWidget {
  final String title;

  const HomeScreen({Key? key, this.title = "Transport News"}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: Text(widget.title, style: const TextStyle(
          fontFamily: 'Schyler', fontSize: 22
        ),),
        centerTitle: true,
        leading: const DrawerWidget(),
      ),
      body: Center(
        child: SizedBox.fromSize(
          size: Size(56, 56), // button width and height
          child: ClipOval(
            child: Material(
              color: Colors.orange, // button color
              child: InkWell(
                splashColor: Colors.green, // splash color
                onTap: () {}, // button pressed
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.file_download), // icon
                    Text(""), // text
                  ],
                ),
              ),
            ),
          ),
        )
      ),
    );
  }
}

class DrawerScreen extends StatefulWidget {
  final ValueSetter setIndex;

  const DrawerScreen({Key? key, required this.setIndex}) : super(key: key);

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          drawerList(Icons.newspaper, "News", 0),
          drawerList(Icons.monetization_on, "StartUP", 1),
          drawerList(Icons.stacked_bar_chart, "BarChart", 2),
          // drawerList(Icons.favorite, "Favorite", 3),
          // drawerList(Icons.archive, "Archive", 4),
          // drawerList(Icons.block, "Spam", 5),
        ],
      ),
    );
  }

  Widget drawerList(IconData icon, String text, int index) {
    return GestureDetector(
      onTap: () {
        widget.setIndex(index);
      },
      child: Container(
        margin: EdgeInsets.only(left: 20, bottom: 12),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            const SizedBox(
              width: 12,
            ),
            Text(
              text,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        ZoomDrawer.of(context)!.toggle();
      },
      icon: Icon(Icons.menu),
      
    );
  }
}
