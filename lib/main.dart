import 'package:clothing_identifier/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  await Supabase.initialize(
    url: 'https://sjesvwkkdmyqbxijrmgy.supabase.co',
    anonKey: dotenv.env['API_KEY'] ?? '',
    // debug: true,
    // authOptions:
    //     const FlutterAuthClientOptions(authFlowType: AuthFlowType.implicit),
    // storageOptions: const StorageClientOptions(retryAttempts: 10),
    // realtimeClientOptions: const RealtimeClientOptions(
    //   logLevel: RealtimeLogLevel.info,
    // ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supabase Clothing Identifier',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: WelcomePage(),
    );
  }
}
