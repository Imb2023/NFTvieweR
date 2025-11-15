import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/models/nft_model.dart';
import '../screens/detail_screen.dart';
import 'responsive_image.dart';

class NftCard extends StatelessWidget {
  final Nft nft;

  const NftCard({super.key, required this.nft});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DetailScreen(nft: nft)),
      ),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// FIX #1 — Remove Expanded and enforce clean aspect ratio
            AspectRatio(
              aspectRatio: 1,
              child: ResponsiveImage(
                networkUrl: nft.image,
                fit: BoxFit.cover,
              ),
            ),

            /// Name section
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                nft.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 400.ms),
    );
  }
}
