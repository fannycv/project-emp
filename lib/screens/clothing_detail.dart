import 'package:clothing_identifier/models/clothing.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ClothingDatailView extends StatelessWidget {
  ClothingDatailView({super.key, required this.clothing});
  final Clothing clothing;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Clothing Detail',
          style:  TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(36, 36, 36, 1),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(clothing.image ?? '', height: 400,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                clothing.description ?? '',
              ),
            ),
            SizedBox(
              height: 280,
              child: othersClothing(),
            ),
          ],
        ),
      ),
    );
  }

  Widget othersClothing() {
    // future builder
    return FutureBuilder<List<Clothing>>(
      future: getData(clothing),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error fetching data'));
        } else {
          final clothing = snapshot.data!;
          return ListView.builder(
            itemCount: clothing.length,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              final item = clothing[index];
              return SizedBox(
                width: 300,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ClothingDatailView(clothing: item),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Card(
                    elevation: 0,
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        Image.network(
                          item.image ?? '',
                          height: 160,
                        ),
                        Text(
                          item.description ?? '',
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  final supabase = Supabase.instance.client;

  Future<List<Clothing>> getData(Clothing item) async {
    try {
      final response = await supabase.rpc(
        'match_clothings',
        params: {
          "query_embedding": item.embedding,
          "match_threshold": 0.89,
          "match_count": 6,
        },
      );

      final tempList = response as List;

      return tempList
          .map((e) => Clothing.fromJson(e))
          .toList()
          .where((element) => element.id != item.id)
          .toList();
    } on FunctionException catch (_) {
      return [];
    } catch (e) {
      return [];
    }
  }
}
