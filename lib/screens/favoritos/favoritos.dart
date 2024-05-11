import 'package:clothing_identifier/models/clothing.dart';
import 'package:clothing_identifier/screens/clothing_detail.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FavoritesPage extends StatelessWidget {
  FavoritesPage({super.key});

  @override
   Widget build(BuildContext context) {
    return Scaffold(
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
            return Card(
              elevation: 4,
              margin: const EdgeInsets.all(8),
              child: InkWell( // Use InkWell for a better tap effect 
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ClothingDatailView(clothing: item),
                    ),
                  );
                },
                child: Column( 
                  children: [
                    Image.network(
                      item.image ?? '',
                      height: 100,
                      width: double.infinity, // Occupy full card width
                      fit: BoxFit.fitHeight,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0), 
                      child: Column( 
                        crossAxisAlignment: CrossAxisAlignment.start, // Align title and icon
                        children: [
                          Text(
                            item.name ?? '',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Align( 
                            alignment: Alignment.centerRight,
                            child: Icon(
                              Icons.favorite, 
                              color: Colors.red,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
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
