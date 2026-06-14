import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/constants/app_colors.dart';

class LoadingShimmer extends StatelessWidget {
  const LoadingShimmer.card({super.key})
    : height = 260,
      borderRadius = 8,
      margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 8);

  const LoadingShimmer.box({
    super.key,
    required this.height,
    this.borderRadius = 8,
    this.margin = EdgeInsets.zero,
  });

  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: Shimmer.fromColors(
        baseColor: AppColors.divider,
        highlightColor: AppColors.surface,
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
    );
  }
}
