import 'package:clothing_identifier/models/clothing.dart';
import 'package:clothing_identifier/screens/clothing_detail.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GaleriaView extends StatelessWidget {
  GaleriaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Clothing>>(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching data'));
          } else {
            final clothing = snapshot.data!;
            return ListView.builder(
              itemCount: clothing.length,
              itemBuilder: (context, index) {
                final item = clothing[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ClothingDatailView(clothing: item),
                          ),
                        );
                      },
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          image: DecorationImage(
                            image: NetworkImage(item.image ?? ''),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: Text(item.name ?? ''),
                      subtitle: Text(item.description ?? ''),
                      trailing: Icon(Icons.favorite_border), 
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
