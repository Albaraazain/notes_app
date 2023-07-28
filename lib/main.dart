import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import '../pages/home_page.dart';
import '../database_info.dart';

void main() {
  final client = SupabaseClient(url,
      apiKey); // the url and the api key are imported from database_info.dart
  runApp(MyApp(client: client));
}

class MyApp extends StatelessWidget {
  final SupabaseClient client;

  const MyApp({Key? key, required this.client}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: HomePage(client: client),
    );
  }
}
