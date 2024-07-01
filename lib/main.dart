import 'package:flutter/material.dart';
import 'package:gmap/gmaps.dart';
//import 'package:gmap/mongoDB.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
//  await MongoDatabase.connect();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: GoogleMaps(),
    );
  }
}
