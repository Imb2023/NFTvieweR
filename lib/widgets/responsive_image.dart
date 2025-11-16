import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';


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
      image = ExtendedImage.network(
        networkUrl!,
        fit: fit,
        cache: true,
        enableLoadState: true,
        gaplessPlayback: true, // prevents GIF restart glitch
        filterQuality: FilterQuality.high,
        loadStateChanged: (state) {
          switch (state.extendedImageLoadState) {
            case LoadState.loading:
              return const Center(
                child: CircularProgressIndicator(strokeWidth: 1.5),
              );
            case LoadState.failed:
              return const Icon(Icons.broken_image, size: 40);
            default:
              return null;
          }
        },
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
