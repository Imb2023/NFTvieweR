import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/nft_model.dart';

class NftService {
  Future<List<Nft>> loadLocalNfts() async {
    // Load the index.json
    final indexContent = await rootBundle.loadString('assets/data/index.json');
    final List<dynamic> nftFiles = json.decode(indexContent);

    // Load and parse each NFT JSON file
    final List<Nft> nfts = await Future.wait(
      nftFiles.map((file) async {
        final jsonString = await rootBundle.loadString('assets/$file');
        final Map<String, dynamic> jsonData = json.decode(jsonString);
        return Nft.fromJson(jsonData);
      }),
    );

    return nfts;
  }
}
