import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/routing/routes.dart';
import '../../../shared/salons_provider.dart';
import '../../../shared/salon_model.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');
final selectedFilterCategoryProvider = StateProvider<String?>((ref) => null);
final selectedFilterRatingProvider = StateProvider<double?>((ref) => null);

class SearchResultsScreen extends ConsumerWidget {
  const SearchResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final query = ref.watch(searchQueryProvider);
    final selectedCategory = ref.watch(selectedFilterCategoryProvider);
    final minRating = ref.watch(selectedFilterRatingProvider);
    final allSalons = ref.watch(salonsProvider);

    final filteredSalons = allSalons.where((salon) {
      final matchesQuery = query.isEmpty || salon.name.toLowerCase().contains(query.toLowerCase()) || salon.category.toLowerCase().contains(query.toLowerCase()) || salon.city.toLowerCase().contains(query.toLowerCase());
      final matchesCategory = selectedCategory == null || salon.category.toLowerCase().contains(selectedCategory.toLowerCase()) || salon.services.any((s) => s.category?.toLowerCase() == selectedCategory.toLowerCase());
      final matchesRating = minRating == null || salon.rating >= minRating;
      return matchesQuery && matchesCategory && matchesRating;
    }).toList();

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(title: const Text('Search Salons'), elevation: 0),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (val) => ref.read(searchQueryProvider.notifier).state = val,
                    decoration: InputDecoration(
                      hintText: 'Search salon names or treatments...',
                      prefixIcon: const Icon(Icons.search, color: AppColors.textLight),
                      filled: true, fillColor: cs.surface,
                      border: OutlineInputBorder(borderRadius: AppRadius.borderMD, borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () => _showFilterSheet(context, ref),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: selectedCategory != null || minRating != null ? AppColors.primaryLight : cs.surface,
                      borderRadius: AppRadius.borderMD,
                      border: Border.all(color: selectedCategory != null || minRating != null ? AppColors.primaryAccent : AppColors.border, width: 1),
                    ),
                    child: Icon(Icons.tune, color: selectedCategory != null || minRating != null ? AppColors.primaryDark : AppColors.textMedium),
                  ),
                ),
              ],
            ),
          ),

          if (selectedCategory != null || minRating != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                height: 36,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    if (selectedCategory != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: InputChip(
                          label: Text(selectedCategory),
                          onDeleted: () => ref.read(selectedFilterCategoryProvider.notifier).state = null,
                          backgroundColor: AppColors.primaryLight, labelStyle: AppTextStyles.bodySmall(color: AppColors.primaryDark),
                          deleteIconColor: AppColors.primaryDark, shape: RoundedRectangleBorder(borderRadius: AppRadius.borderSM),
                        ),
                      ),
                    if (minRating != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: InputChip(
                          label: Text('Rating: $minRating+'),
                          onDeleted: () => ref.read(selectedFilterRatingProvider.notifier).state = null,
                          backgroundColor: AppColors.primaryLight, labelStyle: AppTextStyles.bodySmall(color: AppColors.primaryDark),
                          deleteIconColor: AppColors.primaryDark, shape: RoundedRectangleBorder(borderRadius: AppRadius.borderSM),
                        ),
                      ),
                  ],
                ),
              ),
            ),

          AppSpacing.gapSM,

          Expanded(
            child: filteredSalons.isEmpty
                ? _buildEmptyState(context, ref)
                : ListView.separated(
              padding: const EdgeInsets.all(20.0),
              itemCount: filteredSalons.length,
              separatorBuilder: (context, index) => AppSpacing.gapLG,
              itemBuilder: (context, index) => _buildSalonResultCard(context, filteredSalons[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSalonResultCard(BuildContext context, SalonModel salon) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.borderLG, side: const BorderSide(color: AppColors.border, width: 0.5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(16)), child: Image.asset(salon.imageUrl, height: 160, width: double.infinity, fit: BoxFit.cover)),
              Positioned(
                top: 12, left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.9), borderRadius: AppRadius.borderSM),
                  child: Row(children: [const Icon(Icons.star, color: AppColors.starYellow, size: 14), const SizedBox(width: 4), Text(salon.rating.toString(), style: AppTextStyles.label(color: AppColors.textDark).copyWith(fontWeight: FontWeight.bold))]),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(salon.category, style: AppTextStyles.label(color: AppColors.primaryDark).copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(salon.name, style: AppTextStyles.titleLarge()),
                const SizedBox(height: 6),
                Row(children: [const Icon(Icons.location_on, size: 14, color: AppColors.textLight), const SizedBox(width: 4), Text('${salon.address} • ${salon.city}', style: AppTextStyles.bodySmall(color: AppColors.textMedium))]),
                const Divider(height: 24, color: AppColors.border),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text('${salon.services.length} services available', style: AppTextStyles.bodySmall(color: AppColors.textLight))),
                    ElevatedButton(
                      onPressed: () => context.push('${Routes.salonDetail}/${salon.id}'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryDark, foregroundColor: AppColors.surface,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderMD),
                      ),
                      child: const Text('View Salon'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
              child: const Icon(Icons.search_off, size: 64, color: AppColors.primaryDark),
            ),
            AppSpacing.gapLG,
            Text('No Salons Found', style: AppTextStyles.h3(), textAlign: TextAlign.center),
            AppSpacing.gapSM,
            Text('We couldn\'t find any salons matching your query or filters. Try adjusting your settings.', style: AppTextStyles.bodyMedium(color: AppColors.textMedium), textAlign: TextAlign.center),
            AppSpacing.gapLG,
            ElevatedButton(
              onPressed: () {
                ref.read(searchQueryProvider.notifier).state = '';
                ref.read(selectedFilterCategoryProvider.notifier).state = null;
                ref.read(selectedFilterRatingProvider.notifier).state = null;
              },
              child: const Text('Reset All Filters'),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Consumer(
          builder: (context, ref, _) {
            final activeCat = ref.watch(selectedFilterCategoryProvider);
            final activeRate = ref.watch(selectedFilterRatingProvider);
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Filter Search', style: AppTextStyles.h2()),
                  AppSpacing.gapMD,
                  Text('Category', style: AppTextStyles.titleMedium(color: AppColors.primaryDark)),
                  AppSpacing.gapSM,
                  Wrap(
                    spacing: 8,
                    children: ['Facial', 'Massage', 'Hair', 'Nails'].map((cat) {
                      final isSelected = activeCat?.toLowerCase() == cat.toLowerCase();
                      return ChoiceChip(
                        label: Text(cat), selected: isSelected, selectedColor: AppColors.primaryLight, backgroundColor: AppColors.cardBg,
                        onSelected: (val) => ref.read(selectedFilterCategoryProvider.notifier).state = val ? cat : null,
                      );
                    }).toList(),
                  ),
                  AppSpacing.gapMD,
                  Text('Minimum Rating', style: AppTextStyles.titleMedium(color: AppColors.primaryDark)),
                  AppSpacing.gapSM,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [4.0, 4.5, 4.8].map((rate) {
                      final isSelected = activeRate == rate;
                      return ChoiceChip(
                        label: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.star, color: AppColors.starYellow, size: 14), const SizedBox(width: 4), Text('$rate+')]),
                        selected: isSelected, selectedColor: AppColors.primaryLight, backgroundColor: AppColors.cardBg,
                        onSelected: (val) => ref.read(selectedFilterRatingProvider.notifier).state = val ? rate : null,
                      );
                    }).toList(),
                  ),
                  AppSpacing.gapLG,
                  SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => context.pop(), child: const Text('Apply Filters'))),
                ],
              ),
            );
          },
        );
      },
    );
  }
}