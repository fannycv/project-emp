import 'package:clothing_identifier/models/favorite.dart';
import 'package:clothing_identifier/models/user.dart';

class Clothing {
  late final int? id;
  late final String? name;
  late final String? image;
  late final String? description;
  late final double? price;
  late final String? category;
  late final String? embedding;
  late final User? user;
  late final List<Favorite> favorites;

  Clothing({
    this.id,
    this.name,
    this.image,
    this.description,
    this.price,
    this.category,
    this.embedding,
    this.user,
    this.favorites = const [],
  });

// from json using factory constructor
  factory Clothing.fromJson(Map<String, dynamic> json) {
    List<Favorite> favorites = json['favorites'] != null
        ? List<Favorite>.from(
            json['favorites'].map((x) => Favorite.fromJson(x)),
          )
        : [];

    return Clothing(
      id: json['id'],
      name: json['name'],
      image: getImageUrl(json['image']),
      description: json['description'],
      price: json['price'],
      category: json['category'],
      embedding: json['embedding'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      favorites: favorites,
    );
  }

  // to json
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image,
      'description': description,
      'price': price,
      'category': category,
      'embedding': embedding,
    };
  }

  bool isFavorite(String userId) {
    return favorites.any((element) => element.userId == userId);
  }

  static String getImageUrl(String path) {
    return 'https://sjesvwkkdmyqbxijrmgy.supabase.co/storage/v1/object/public/images/$path';
  }
}
