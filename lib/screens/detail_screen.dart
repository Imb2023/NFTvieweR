import 'package:flutter/material.dart';
import '../core/models/nft_model.dart';
import '../widgets/nft_attribute_chip.dart';
import '../widgets/responsive_image.dart'; // add this import

class DetailScreen extends StatelessWidget {
  final Nft nft;
  const DetailScreen({super.key, required this.nft});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(nft.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Replace AspectRatio + Image.network with ResponsiveImage
          ResponsiveImage(
            networkUrl: nft.image,
            fit: BoxFit.cover,
          ),

          const SizedBox(height: 16),
          Text(
            nft.description,
            style: const TextStyle(fontSize: 15),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: nft.attributes
                .map((attr) => NftAttributeChip(attr: attr))
                .toList(),
          ),
        ],
      ),
    );
  }
}
