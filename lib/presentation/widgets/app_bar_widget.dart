import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';

class VilasAppBar extends StatelessWidget implements PreferredSizeWidget {
  const VilasAppBar({
    super.key,
    this.title,
    this.showSearch = true,
    this.actions,
    this.leading,
  });

  final String? title;
  final bool showSearch;
  final List<Widget>? actions;
  final Widget? leading;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading,
      title: title == null
          ? const VilasLogo()
          : Text(
              title!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.primary,
                fontSize: 20,
              ),
            ),
      actions: [
        if (showSearch)
          IconButton(
            tooltip: AppStrings.search,
            onPressed: () => context.push('/busca'),
            icon: const Icon(Icons.search),
          ),
        ...?actions,
      ],
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: ColoredBox(
          color: AppColors.primary,
          child: SizedBox(height: 1, width: double.infinity),
        ),
      ),
    );
  }
}

class VilasLogo extends StatelessWidget {
  const VilasLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/vilas_logo.svg',
      height: 34,
      semanticsLabel: AppStrings.appName,
    );
  }
}
