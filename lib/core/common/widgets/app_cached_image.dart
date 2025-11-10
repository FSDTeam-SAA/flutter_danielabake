import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../shimmer/shimmer_loader.dart';

class AppCachedImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final IconData icon;
  final Color iconColor;
  final BorderRadius? borderRadius;

  const AppCachedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.icon = Icons.error,
    this.iconColor = Colors.red,
    this.borderRadius,
  });

  // Helper: safely convert double to int for caching
  static int _safeToInt(double? value, {int fallback = 300}) {
    if (value == null || value.isNaN || value.isInfinite || value <= 0) {
      return fallback;
    }
    return value.round(); // Use round() instead of toInt() for safety
  }

  @override
  Widget build(BuildContext context) {
    // Handle null or empty imageUrl early
    if (imageUrl == null || imageUrl!.isEmpty) {
      return ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: Container(
          width: width,
          height: height,
          color: Colors.grey.shade200,
          child: Center(
            child: Icon(
              icon,
              color: iconColor,
              size: width != null && width!.isFinite ? width! * 0.5 : 50,
            ),
          ),
        ),
      );
    }
    // Safely compute cache dimensions
    final int cacheWidth = _safeToInt(width, fallback: 300);
    final int cacheHeight = _safeToInt(height, fallback: 450);

    // Optional: scale cache size based on device pixel ratio
    final scale = MediaQuery.of(context).devicePixelRatio;
    final int scaledCacheWidth = (cacheWidth * scale).round().clamp(100, 800);
    final int scaledCacheHeight = (cacheHeight * scale).round().clamp(
      100,
      1200,
    );

    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: CachedNetworkImage(
        memCacheWidth: scaledCacheWidth,
        memCacheHeight: scaledCacheHeight,
        maxWidthDiskCache: scaledCacheWidth,
        maxHeightDiskCache: scaledCacheHeight,
        imageUrl: imageUrl ?? '',
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => ShimmerLoader(
          isLoading: true,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: borderRadius,
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: Colors.grey.shade200,
          child: Icon(
            icon,
            color: iconColor,
            size: width != null && width!.isFinite ? width! * 0.5 : 50,
          ),
        ),
      ),
    );
  }
}
