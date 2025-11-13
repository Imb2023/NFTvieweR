import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/nft_model.dart';

class NftService {
  Future<List<Nft>> loadLocalNfts() async {
    // Load Flutter’s asset manifest
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    // Find all files inside assets/nfts/ that end with .json
    final nftPaths = manifestMap.keys
        .where(
            (path) => path.startsWith('assets/nfts/') && path.endsWith('.json'))
        .toList();

    // Load and parse each NFT JSON file
    final List<Nft> nfts = [];
    for (final path in nftPaths) {
      final jsonString = await rootBundle.loadString(path);
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      nfts.add(Nft.fromJson(jsonData));
    }

    return nfts;
  }
}
