import 'package:clothing_identifier/screens/home/home.dart';
import 'package:clothing_identifier/screens/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final supabase = Supabase.instance.client;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  await Supabase.initialize(
    url: 'https://sjesvwkkdmyqbxijrmgy.supabase.co',
    anonKey: dotenv.env['API_KEY'] ?? '',
    debug: true,
    storageOptions: const StorageClientOptions(retryAttempts: 10),
  );
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supabase Clothing Identifier',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        useMaterial3: true,
      ),
      home:
          supabase.auth.currentUser == null ? WelcomePage() : const HomeView(),
    );
  }
}
