import 'package:clothing_identifier/models/favorite.dart';
import 'package:clothing_identifier/screens/clothing_detail.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class ClothingsFavoritesView extends StatefulWidget {
  const ClothingsFavoritesView({super.key});

  @override
  _ClothingsFavoritesViewState createState() => _ClothingsFavoritesViewState();
}

class _ClothingsFavoritesViewState extends State<ClothingsFavoritesView> {
  late Future<List<Favorite>> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    _favoritesFuture = getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Favorite>>(
        future: _favoritesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching data'));
          } else {
            final clothing = snapshot.data!;
            return RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  _favoritesFuture = getData();
                });
              },
              child: ListView.builder(
                itemCount: clothing.length,
                itemBuilder: (context, index) {
                  final item = clothing[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ClothingDatailView(
                              clothing: item.clothing!,
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
                                  item.clothing?.image ?? '',
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
                                          fontSize: 14, color: Colors.white),
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
                                  shape: BoxShape.circle,
                                  color: Colors.black.withOpacity(0.5),
                                ),
                                child: IconButton(
                                  onPressed: () async {
                                    try {
                                      await supabase
                                          .from('clothingfavorites')
                                          .delete()
                                          .eq('clothing_id', item.clothing!.id!)
                                          .eq('user_id',
                                              supabase.auth.currentUser!.id);

                                      setState(
                                        () {
                                          _favoritesFuture = getData();
                                        },
                                      );
                                    } catch (e) {
                                      print('Error removing favorite: $e');
                                    }
                                  },
                                  icon: const Icon(Icons.favorite_rounded,
                                      color: Colors.blueGrey),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }

  Future<List<Favorite>> getData() async {
    try {
      final response = await supabase
          .from('clothingfavorites')
          .select('*, user:users(*), clothing:clothings(*)')
          .eq('user_id', supabase.auth.currentUser?.id ?? '')
          .order('id', ascending: false);

      final tempList = response as List;

      return tempList.map((e) => Favorite.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }
}
