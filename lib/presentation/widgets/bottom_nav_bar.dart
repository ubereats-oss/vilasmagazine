import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';

class VilasBottomNavBar extends StatelessWidget {
  const VilasBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.inactive,
        selectedLabelStyle: Theme.of(context).textTheme.labelSmall,
        unselectedLabelStyle: Theme.of(context).textTheme.labelSmall,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: AppStrings.navHome,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            label: AppStrings.navNews,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            label: AppStrings.navMagazine,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.place_outlined),
            label: AppStrings.navGuide,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            label: AppStrings.navAbout,
          ),
        ],
      ),
    );
  }
}
