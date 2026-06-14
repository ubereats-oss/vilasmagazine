import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import 'loading_shimmer.dart';

class ArticleImage extends StatelessWidget {
  const ArticleImage({
    super.key,
    required this.imageUrl,
    required this.height,
    this.width = double.infinity,
    this.fit = BoxFit.cover,
    this.borderRadius = 8,
  });

  final String imageUrl;
  final double height;
  final double width;
  final BoxFit fit;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final child = imageUrl.isEmpty
        ? const _ImageFallback()
        : CachedNetworkImage(
            imageUrl: imageUrl,
            width: width,
            height: height,
            fit: fit,
            placeholder: (_, _) =>
                LoadingShimmer.box(height: height, borderRadius: borderRadius),
            errorWidget: (_, _, _) => const _ImageFallback(),
          );

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(width: width, height: height, child: child),
    );
  }
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.imagePlaceholder,
      child: Center(
        child: Icon(
          Icons.newspaper_outlined,
          color: AppColors.inactive,
          size: 42,
        ),
      ),
    );
  }
}
