import 'package:clothing_identifier/models/clothing.dart';
import 'package:clothing_identifier/screens/clothing_detail.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ClothingView extends StatelessWidget {
  ClothingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Clothing'),
      ),
      body: FutureBuilder<List<Clothing>>(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching data'));
          } else {
            final clothing = snapshot.data!;
            return ListView.builder(
              itemCount: clothing.length,
              itemBuilder: (context, index) {
                final item = clothing[index];
                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ClothingDatailView(clothing: item),
                      ),
                    );
                  },
                  leading: Image.network(
                    item.image ?? '',
                    height: 120,
                  ),
                  subtitle: Text(
                    item.description ?? '',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  final supabase = Supabase.instance.client;

  Future<List<Clothing>> getData() async {
    try {
      final response = await supabase.from('clothings').select('*');

      final tempList = response as List;

      return tempList.map((e) => Clothing.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }
}
