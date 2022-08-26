// import 'package:csv/csv.dart';
// import 'package:flutter/material.dart';
// import 'package:ext_storage/ext_storage.dart';
// import 'dart:io';
// import 'package:permission_handler/permission_handler.dart';
//
//
// class Import_to_csv extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key, required this.title}) : super(key: key);
//
//   final String title;
//
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
//
//   void _generateCsvFile() async {
//     Map<Permission, PermissionStatus> statuses = await [
//       Permission.storage,
//     ].request();
//
//     List<dynamic> associateList = [
//       {"number": 1, "lat": "14.97534313396318", "lon": "101.22998536005622"},
//       {"number": 2, "lat": "14.97534313396318", "lon": "101.22998536005622"},
//       {"number": 3, "lat": "14.97534313396318", "lon": "101.22998536005622"},
//       {"number": 4, "lat": "14.97534313396318", "lon": "101.22998536005622"}
//     ];
//
//     List<List<dynamic>> rows = [];
//
//     List<dynamic> row = [];
//     row.add("number");
//     row.add("latitude");
//     row.add("longitude");
//     rows.add(row);
//     for (int i = 0; i < associateList.length; i++) {
//       List<dynamic> row = [];
//       row.add(associateList[i]["number"] - 1);
//       row.add(associateList[i]["lat"]);
//       row.add(associateList[i]["lon"]);
//       rows.add(row);
//     }
//
//     String csv = const ListToCsvConverter().convert(rows);
//
//     String dir = await ExtStorage.getExternalStoragePublicDirectory(
//         ExtStorage.DIRECTORY_DOWNLOADS);
//     print("dir $dir");
//     String file = "$dir";
//
//     File f = File(file + "/filename.csv");
//
//     f.writeAsString(csv);
//
//     setState(() {
//       _counter++;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headline4,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _generateCsvFile,
//         tooltip: 'Increment',
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }