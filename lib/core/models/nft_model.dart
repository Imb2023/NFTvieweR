import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class NftAttribute {
  final String traitType;
  final String value;

  NftAttribute({
    required this.traitType,
    required this.value,
  });

  factory NftAttribute.fromJson(Map<String, dynamic> json) {
    return NftAttribute(
      traitType: json['trait_type'] ?? '',
      value: json['value'] ?? '',
    );
  }
}

class Nft {
  final String name;
  final String description;
  final String image;
  final String dna;
  final int edition;
  final int date;
  final String imageHash;
  final List<NftAttribute> attributes;

  Nft({
    required this.name,
    required this.description,
    required this.image,
    required this.dna,
    required this.edition,
    required this.date,
    required this.imageHash,
    required this.attributes,
  });

  factory Nft.fromJson(Map<String, dynamic> json) {
    final attrs = (json['attributes'] as List<dynamic>?)
            ?.map<NftAttribute>(
                (a) => NftAttribute.fromJson(a as Map<String, dynamic>))
            .toList() ??
        <NftAttribute>[];

    return Nft(
      name: json['name'] ?? 'Unnamed NFT',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      dna: json['dna'] ?? '',
      edition: json['edition'] ?? 0,
      date: json['date'] ?? 0,
      imageHash: json['imageHash'] ?? '',
      attributes: attrs,
    );
  }

  static Future<Nft> fromAsset(String path) async {
    final jsonString = await rootBundle.loadString(path);
    final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
    return Nft.fromJson(jsonData);
  }
}
