import 'package:clothing_identifier/models/clothing.dart';
import 'package:clothing_identifier/models/user.dart';

class Favorite {
  late final int? id;
  late final User? user;
  late final String? userId;
  late final int? clothingId;
  late final int? outfitId;
  late final Clothing? clothing;

  Favorite({
    this.id,
    this.user,
    this.clothing,
    this.clothingId,
    this.outfitId,
    this.userId,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      id: json['id'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      clothing:
          json['clothing'] != null ? Clothing.fromJson(json['clothing']) : null,
      clothingId: json['clothing_id'],
      outfitId: json['outfit_id'],
      userId: json['user_id'],
    );
  }

  // to json
  Map<String, dynamic> toJson() {
    return {
      'user': user?.toJson(),
      'clothing': clothing?.toJson(),
    };
  }
}
