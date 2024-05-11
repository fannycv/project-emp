class Clothing {
  late final int? id;
  late final String? name;
  late final String? image;
  late final String? description;
  late final double? price;
  late final String? category;
  late final String? embedding;

  Clothing({
    this.id,
    this.name,
    this.image,
    this.description,
    this.price,
    this.category,
    this.embedding,
  });

// from json using factory constructor
  factory Clothing.fromJson(Map<String, dynamic> json) {
    return Clothing(
      id: json['id'],
      name: json['name'],
      image: getImageUrl(json['image']),
      description: json['description'],
      price: json['price'],
      category: json['category'],
      embedding: json['embedding'],
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

  static String getImageUrl(String path) {
    return 'https://sjesvwkkdmyqbxijrmgy.supabase.co/storage/v1/object/public/images/$path';
  }
}
