import 'package:clothing_identifier/models/clothing.dart';
import 'package:clothing_identifier/screens/outfit_detail.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class OutfitsView extends StatefulWidget {
  const OutfitsView({super.key});

  @override
  State<OutfitsView> createState() => _OutfitsViewState();
}

class _OutfitsViewState extends State<OutfitsView> {
  late Future<List<Clothing>> dataFuture;
  @override
  void initState() {
    super.initState();
    dataFuture = getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Clothing>>(
        future: dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching data'));
          } else {
            final clothing = snapshot.data!;
            return ListView.builder(
              itemCount: clothing.length,
              itemBuilder: (context, index) {
                final item = clothing[index];

                bool isFavorite =
                    item.isFavorite(supabase.auth.currentUser?.id ?? '');

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OutfitDatailView(
                            clothing: item,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 0.1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20.0)),
                            child: SizedBox(
                              height: 250,
                              width: double.infinity,
                              child: Image.network(
                                item.image ?? '',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 5,
                            left: 15,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.person,
                                      color: Colors.white, size: 18),
                                  const SizedBox(width: 5),
                                  Text(
                                    'Creado por @${item.user?.username}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 5,
                            right: 5,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                onPressed: () async {
                                  if (isFavorite) {
                                    await supabase
                                        .from('outfitsfavorites')
                                        .delete()
                                        .eq('outfit_id', item.id ?? '')
                                        .eq(
                                            'user_id',
                                            supabase.auth.currentUser?.id ??
                                                '');
                                  } else {
                                    await supabase
                                        .from('outfitsfavorites')
                                        .insert({
                                          'outfit_id': item.id,
                                          'user_id':
                                              supabase.auth.currentUser?.id,
                                        })
                                        .select()
                                        .single();
                                  }

                                  refreshData();
                                },
                                icon: Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFavorite ? Colors.red : Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
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

  Future<void> refreshData() async {
    setState(() {
      dataFuture = getData();
    });
  }

  Future<List<Clothing>> getData() async {
    try {
      final response = await supabase
          .from('outfits')
          .select('*, user:users(*),favorites:outfitsfavorites(*)')
          .order('id', ascending: false);

      final tempList = response as List;

      return tempList.map((e) => Clothing.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }
}
