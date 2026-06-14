import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/url_launcher_helper.dart';
import '../../widgets/app_bar_widget.dart';

class GuideScreen extends StatefulWidget {
  const GuideScreen({super.key});

  @override
  State<GuideScreen> createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> {
  late final Future<List<GuideCategory>> _categoriesFuture;
  final TextEditingController _searchController = TextEditingController();
  int _selectedIndex = 0;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _loadCategories();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const VilasAppBar(title: AppStrings.guideTitle),
      body: FutureBuilder<List<GuideCategory>>(
        future: _categoriesFuture,
        builder: (context, snapshot) {
          final categories = snapshot.data ?? const <GuideCategory>[];
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final selected = categories[_selectedIndex];
          final establishments = selected.establishments
              .where((item) {
                if (_query.isEmpty) {
                  return true;
                }
                return item.name.toLowerCase().contains(_query) ||
                    item.address.toLowerCase().contains(_query);
              })
              .toList(growable: false);

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: AppStrings.guideSearchHint,
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() => _query = value.trim().toLowerCase());
                    },
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                sliver: SliverGrid.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.82,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final selectedCategory = index == _selectedIndex;
                    return _GuideCategoryTile(
                      category: category,
                      selected: selectedCategory,
                      onTap: () => setState(() => _selectedIndex = index),
                    );
                  },
                ),
              ),
              if (establishments.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: Text(AppStrings.guideNoResults)),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  sliver: SliverList.separated(
                    itemCount: establishments.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      return _EstablishmentCard(
                        establishment: establishments[index],
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Future<List<GuideCategory>> _loadCategories() async {
    final raw = await rootBundle.loadString('assets/data/guia_local.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final categories = json['categorias'] as List<dynamic>;
    return categories
        .map((item) => GuideCategory.fromJson(item as Map<String, dynamic>))
        .toList(growable: false);
  }
}

class _GuideCategoryTile extends StatelessWidget {
  const _GuideCategoryTile({
    required this.category,
    required this.selected,
    required this.onTap,
  });

  final GuideCategory category;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.secondary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: selected ? AppColors.surface : AppColors.background,
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.divider,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(_iconFor(category.icon), color: color),
              const SizedBox(height: 6),
              Text(
                category.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(color: color, fontSize: 11),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _iconFor(String value) {
    return switch (value) {
      'restaurant' => Icons.restaurant_outlined,
      'health' => Icons.local_hospital_outlined,
      'beauty' => Icons.spa_outlined,
      'education' => Icons.school_outlined,
      'real_estate' => Icons.home_work_outlined,
      'services' => Icons.handyman_outlined,
      'commerce' => Icons.storefront_outlined,
      'leisure' => Icons.celebration_outlined,
      _ => Icons.place_outlined,
    };
  }
}

class _EstablishmentCard extends StatelessWidget {
  const _EstablishmentCard({required this.establishment});

  final Establishment establishment;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              establishment.name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            _InfoLine(
              icon: Icons.place_outlined,
              label: AppStrings.address,
              value: establishment.address,
            ),
            const SizedBox(height: 6),
            _InfoLine(
              icon: Icons.phone_outlined,
              label: AppStrings.phone,
              value: establishment.phone,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: () => UrlLauncherHelper.call(establishment.phone),
                  icon: const Icon(Icons.call_outlined),
                  label: const Text(AppStrings.call),
                ),
                ElevatedButton.icon(
                  onPressed: () =>
                      UrlLauncherHelper.whatsapp(establishment.whatsapp),
                  icon: const Icon(Icons.chat_outlined),
                  label: const Text(AppStrings.whatsapp),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            '$label: $value',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

class GuideCategory {
  const GuideCategory({
    required this.name,
    required this.icon,
    required this.establishments,
  });

  final String name;
  final String icon;
  final List<Establishment> establishments;

  factory GuideCategory.fromJson(Map<String, dynamic> json) {
    final establishments = json['estabelecimentos'] as List<dynamic>;
    return GuideCategory(
      name: json['nome'] as String,
      icon: json['icone'] as String,
      establishments: establishments
          .map((item) => Establishment.fromJson(item as Map<String, dynamic>))
          .toList(growable: false),
    );
  }
}

class Establishment {
  const Establishment({
    required this.name,
    required this.address,
    required this.phone,
    required this.whatsapp,
  });

  final String name;
  final String address;
  final String phone;
  final String whatsapp;

  factory Establishment.fromJson(Map<String, dynamic> json) {
    return Establishment(
      name: json['nome'] as String,
      address: json['endereco'] as String,
      phone: json['telefone'] as String,
      whatsapp: json['whatsapp'] as String,
    );
  }
}
