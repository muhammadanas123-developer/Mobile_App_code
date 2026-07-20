import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../shared/salons_provider.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final salons = ref.watch(salonsProvider);

    final cs = Theme.of(context).colorScheme;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: cs.surface,
        appBar: AppBar(
          title: const Text('My Favorites'),
          elevation: 0,
          bottom: const TabBar(
            indicatorColor: AppColors.primaryDark,
            labelColor: AppColors.primaryDark,
            unselectedLabelColor: AppColors.textLight,
            tabs: [
              Tab(text: 'Saved Salons'),
              Tab(text: 'Saved Services'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Salons Tab
            salons.isEmpty
                ? _buildEmptyState('No Saved Salons')
                : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: salons.length,
              separatorBuilder: (context, index) => AppSpacing.gapMD,
              itemBuilder: (context, index) {
                final salon = salons[index];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: AppRadius.borderLG,
                    border: Border.all(color: AppColors.border, width: 0.5),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: AppRadius.borderMD,
                        child: Image.asset(
                          salon.imageUrl,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              salon.name,
                              style: AppTextStyles.titleMedium(),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.star, color: AppColors.starYellow, size: 12),
                                const SizedBox(width: 4),
                                Text(
                                  '${salon.rating} (${salon.reviewsCount} reviews)',
                                  style: AppTextStyles.bodySmall(color: AppColors.textMedium),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              salon.city,
                              style: AppTextStyles.bodySmall(color: AppColors.textLight),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.favorite, color: AppColors.errorText),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Removed from favorites')),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),

            // Services Tab
            ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildServiceFavoriteCard(
                  context,
                  title: 'Botanical Glow Facial',
                  salonName: 'Maison de Beauté',
                  price: 145.0,
                  duration: 90,
                ),
                AppSpacing.gapMD,
                _buildServiceFavoriteCard(
                  context,
                  title: 'Signature Hydro-Facial',
                  salonName: 'Ethereal Skin Studio',
                  price: 120.0,
                  duration: 60,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceFavoriteCard(
      BuildContext context, {
        required String title,
        required String salonName,
        required double price,
        required int duration,
      }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.borderLG,
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.titleMedium(),
                ),
                const SizedBox(height: 4),
                Text(
                  salonName,
                  style: AppTextStyles.bodySmall(color: AppColors.textMedium),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '$duration min',
                      style: AppTextStyles.bodySmall(color: AppColors.textLight),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Rs ${price.toStringAsFixed(0)}',
                      style: AppTextStyles.bodyMedium(color: AppColors.textDark).copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.favorite, color: AppColors.errorText),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String title) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.favorite_border, size: 64, color: AppColors.textLight),
          const SizedBox(height: 16),
          Text(title, style: AppTextStyles.h3()),
        ],
      ),
    );
  }
}