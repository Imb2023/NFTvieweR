import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ResponsiveImage extends StatelessWidget {
  final String? assetPath;
  final String? networkUrl;
  final double? maxWidthOverride;
  final BoxFit fit;

  const ResponsiveImage({
    super.key,
    this.assetPath,
    this.networkUrl,
    this.maxWidthOverride,
    this.fit = BoxFit.contain,
  }) : assert(assetPath != null || networkUrl != null,
            'Provide either assetPath or networkUrl');

  double _defaultMaxWidth(double screenWidth) {
    if (screenWidth >= 2560) return 900;
    if (screenWidth >= 1600) return 700;
    if (screenWidth >= 1200) return 500;
    if (screenWidth >= 800) return 420;
    return 320;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final targetWidth = maxWidthOverride ?? _defaultMaxWidth(screenWidth);

    Widget image;
    if (assetPath != null) {
      image = Image.asset(assetPath!, fit: fit);
    } else {
      image = CachedNetworkImage(
        imageUrl: networkUrl!,
        fit: fit,
        placeholder: (_, __) => const Center(
          child: CircularProgressIndicator(strokeWidth: 1.5),
        ),
        errorWidget: (_, __, ___) => const Icon(Icons.broken_image, size: 40),
      );
    }

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: targetWidth),
        child: image,
      ),
    );
  }
}
