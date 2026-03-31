import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../core/extension/context_extension.dart';

import '../constant/app_assets.dart';
import 'custom_shimmer.dart';

class FlexibleImage extends StatelessWidget {
  final dynamic source;
  final BorderRadiusGeometry borderRadius;
  final bool isCircular;
  final Widget? placeholder;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final bool isProduct;
  final bool isCategory;

  // List of fallback images
  static const List<String> _fallbackImages = [
    AppAssets.fallBackBanner1,
    AppAssets.fallBackBanner2,
    AppAssets.fallBackBanner3,
  ];

  const FlexibleImage({
    super.key,
    required this.source,
    this.borderRadius = BorderRadius.zero,
    this.isCircular = false,
    this.placeholder,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.isProduct = false,
    this.isCategory = false,
  });

  bool _isNetworkImage(String path) {
    return Uri.tryParse(path)?.hasAbsolutePath ?? false;
  }

  bool _isFileImage(String path) {
    return File(path).existsSync();
  }

  bool _isMemoryImage(dynamic data) {
    return data is Uint8List;
  }

  // Get a random fallback image
  String _getRandomFallbackImage() {
    final random = Random();
    return _fallbackImages[random.nextInt(_fallbackImages.length)];
  }

  Widget _defaultErrorImage(BuildContext context) {
    return Container(
      height: height,
      width: width,
      color: context.colorScheme.secondary.withValues(alpha: 0.1),
      child: Image.asset(
        isProduct
            ? AppAssets.fallBackProduct
            : isCategory
            ? AppAssets.fallBackCategory
            : _getRandomFallbackImage(),
        fit: BoxFit.cover,
      ),    );
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    try {
      if (source is String) {
        if (_isFileImage(source)) {
          imageWidget = Image.file(
            File(source),
            fit: fit,
            errorBuilder: (context, error, stackTrace) =>
                _defaultErrorImage(context),
          );
        } else if (_isNetworkImage(source)) {
          imageWidget = CachedNetworkImage(
            imageUrl: source,
            placeholder: (context, url) =>
                placeholder ??
                Center(child: CustomShimmerWidget(height: height)),
            errorWidget: (context, url, error) => _defaultErrorImage(context),
            fit: fit,
          );
        } else {
          imageWidget = Image.asset(
            source,
            fit: fit,
            errorBuilder: (context, error, stackTrace) =>
                _defaultErrorImage(context),
          );
        }
      } else if (_isMemoryImage(source)) {
        imageWidget = Image.memory(
          source,
          fit: fit,
          errorBuilder: (context, error, stackTrace) =>
              _defaultErrorImage(context),
        );
      } else {
        imageWidget = _defaultErrorImage(context);
      }
    } catch (_) {
      imageWidget = _defaultErrorImage(context);
    }

    return ClipRRect(
      borderRadius: isCircular ? BorderRadius.circular(1000) : borderRadius,
      child: SizedBox(width: width, height: height, child: imageWidget),
    );
  }
}
