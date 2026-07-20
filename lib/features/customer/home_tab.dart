import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../authentication/presentation/auth_state_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/routing/routes.dart';
import '../../../shared/favorites_provider.dart';
import 'search_results_screen.dart';

/// Refined HomeTab - Pakistan-based demo data with favorites on salon cards
class HomeTab extends ConsumerWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authStateProvider);
    final user = auth.user;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
        title: const Text('Beauty Personalized by ai'),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_none_outlined), onPressed: () => context.push(Routes.notifications)),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(radius: 18, backgroundImage: AssetImage(user?.avatarUrl ?? AppAssets.avatarUser)),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search row
            Row(
              children: [
                Expanded(
                  child: TextField(
                    readOnly: true,
                    onTap: () => context.push(Routes.searchResults),
                    decoration: InputDecoration(
                      hintText: 'Search for services or salons...',
                      prefixIcon: const Icon(Icons.search, color: AppColors.textLight),
                      filled: true,
                      fillColor: cs.surface,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      border: OutlineInputBorder(borderRadius: AppRadius.borderMD, borderSide: BorderSide.none),
                      enabledBorder: OutlineInputBorder(borderRadius: AppRadius.borderMD, borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(borderRadius: AppRadius.borderMD, borderSide: BorderSide.none),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () => context.push(Routes.searchResults),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: cs.surface, borderRadius: AppRadius.borderMD),
                    child: const Icon(Icons.tune, color: AppColors.primaryDark),
                  ),
                ),
              ],
            ),
            AppSpacing.gapLG,

            Text('Categories', style: AppTextStyles.titleLarge()),
            AppSpacing.gapSM,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCategoryItem(context, ref, 'Hair', Icons.content_cut, isSelected: true),
                _buildCategoryItem(context, ref, 'Skin', Icons.face_retouching_natural_outlined, isSelected: false),
                _buildCategoryItem(context, ref, 'Nails', Icons.back_hand_outlined, isSelected: false),
                _buildCategoryItem(context, ref, 'Spa', Icons.local_florist_outlined, isSelected: false),
              ],
            ),
            AppSpacing.gapLG,

            // Recommended for you card
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(color: AppColors.primaryDark, borderRadius: AppRadius.borderLG),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.primaryLight.withValues(alpha: 0.15), borderRadius: AppRadius.borderSM),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [const Icon(Icons.auto_awesome, color: AppColors.primaryAccent, size: 12), const SizedBox(width: 4),
                        Text('ai INSIGHTS', style: AppTextStyles.label(color: AppColors.primaryAccent).copyWith(fontWeight: FontWeight.bold, fontSize: 10))],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('Recommended For You', style: AppTextStyles.titleLarge(color: Colors.white)),
                  const SizedBox(height: 6),
                  Text('Based on your recent search for "hydrating facials", we found three specialists available this afternoon.',
                      style: AppTextStyles.bodySmall(color: AppColors.primaryLight).copyWith(fontSize: 13, height: 1.4)),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: AppRadius.borderMD, border: Border.all(color: Colors.white.withValues(alpha: 0.1))),
                    child: Row(children: [
                      ClipRRect(borderRadius: AppRadius.borderSM, child: Image.asset(AppAssets.faceScan, width: 50, height: 50, fit: BoxFit.cover)),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Herbal Glow Facial', style: AppTextStyles.titleSmall(color: Colors.white)),
                        const SizedBox(height: 4),
                        Text('Shahnaz Hair & Beauty • 2:30 PM Today', style: AppTextStyles.bodySmall(color: AppColors.primaryLight)),
                      ])),
                    ]),
                  ),
                ],
              ),
            ),
            AppSpacing.gapLG,

            // Featured
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('Featured Salons', style: AppTextStyles.titleLarge()),
                TextButton(onPressed: () {}, child: Text('View All', style: AppTextStyles.bodyMedium(color: AppColors.textLight)))],
            ),
            AppSpacing.gapXS,
            SizedBox(
              height: 240,
              child: ListView(scrollDirection: Axis.horizontal, children: [
                _buildFeaturedSalonCard(context, ref, id: '3', name: 'Glow & Grace Studio', imageAsset: AppAssets.salonInterior, rating: '4.9', address: 'DHA Phase 6, Karachi'),
                const SizedBox(width: 16),
                _buildFeaturedSalonCard(context, ref, id: '1', name: 'Shahnaz Hair & Beauty', imageAsset: AppAssets.salonInterior, rating: '4.8', address: 'MM Alam Road, Lahore'),
                const SizedBox(width: 16),
                _buildFeaturedSalonCard(context, ref, id: '2', name: 'The Nail Lounge', imageAsset: AppAssets.salonInterior, rating: '4.7', address: 'Jinnah Super, Islamabad'),
              ]),
            ),
            AppSpacing.gapLG,

            // Near You
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('Near You', style: AppTextStyles.titleLarge()),
                Row(children: [const Icon(Icons.location_on, size: 14, color: AppColors.textMedium), const SizedBox(width: 4),
                  Text('Lahore, Punjab', style: AppTextStyles.bodySmall(color: AppColors.textMedium).copyWith(fontWeight: FontWeight.bold))])],
            ),
            AppSpacing.gapSM,
            _buildNearYouItem(context, ref, name: 'Gulberg Hair Salon', rating: '4.7', distance: '1.2 km', tags: ['HAIR', 'COLOR'], id: '1', imageAsset: AppAssets.salonInterior),
            AppSpacing.gapMD,
            _buildNearYouItem(context, ref, name: 'Nail Art Studio', rating: '4.9', distance: '2.5 km', tags: ['NAILS', 'VEGAN'], id: '2', imageAsset: AppAssets.salonInterior),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, WidgetRef ref, String label, IconData icon, {required bool isSelected}) {
    return GestureDetector(
      onTap: () { ref.read(selectedFilterCategoryProvider.notifier).state = label; context.push(Routes.searchResults); },
      child: Column(children: [
        Container(width: 60, height: 60,
            decoration: BoxDecoration(color: isSelected ? AppColors.primaryLight : AppColors.cardBg, shape: BoxShape.circle),
            child: Icon(icon, color: isSelected ? AppColors.primaryDark : AppColors.textMedium, size: 24)),
        const SizedBox(height: 8),
        Text(label, style: AppTextStyles.bodySmall(color: isSelected ? AppColors.primaryDark : AppColors.textMedium).copyWith(fontWeight: FontWeight.bold)),
      ]),
    );
  }

  Widget _buildFeaturedSalonCard(BuildContext context, WidgetRef ref, {required String id, required String name, required String imageAsset, required String rating, required String address}) {
    final cs = Theme.of(context).colorScheme;
    final favs = ref.watch(favoritesProvider);
    final isFav = favs.contains(id);

    return GestureDetector(
      onTap: () => context.push('${Routes.salonDetail}/$id'),
      child: Container(
        width: 260,
        decoration: BoxDecoration(color: cs.surface, borderRadius: AppRadius.borderLG, border: Border.all(color: AppColors.border, width: 0.5)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Stack(children: [
            ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(16)), child: Image.asset(imageAsset, height: 120, width: double.infinity, fit: BoxFit.cover)),
            Positioned(top: 10, left: 10, child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.9), borderRadius: AppRadius.borderSM),
              child: Row(children: [const Icon(Icons.star, color: AppColors.starYellow, size: 12), const SizedBox(width: 4), Text(rating, style: AppTextStyles.label(color: AppColors.textDark).copyWith(fontWeight: FontWeight.bold, fontSize: 10))]),
            )),
            Positioned(
              top: 8, right: 8,
              child: GestureDetector(
                onTap: () => ref.read(favoritesProvider.notifier).toggle(id),
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white.withValues(alpha: 0.9),
                  child: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? AppColors.errorText : AppColors.textDark,
                    size: 18,
                  ),
                ),
              ),
            ),
          ]),
          Padding(padding: const EdgeInsets.all(12.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(name, style: AppTextStyles.titleMedium()),
            const SizedBox(height: 4), Text(address, style: AppTextStyles.bodySmall(color: AppColors.textLight)),
          ])),
        ]),
      ),
    );
  }

  Widget _buildNearYouItem(BuildContext context, WidgetRef ref, {required String name, required String rating, required String distance, required List<String> tags, required String id, required String imageAsset}) {
    final cs = Theme.of(context).colorScheme;
    final favs = ref.watch(favoritesProvider);
    final isFav = favs.contains(id);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: cs.surface, borderRadius: AppRadius.borderLG, border: Border.all(color: AppColors.border, width: 0.5)),
      child: Row(children: [
        ClipRRect(borderRadius: AppRadius.borderMD, child: Image.asset(imageAsset, width: 80, height: 80, fit: BoxFit.cover)),
        const SizedBox(width: 16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(name, style: AppTextStyles.titleMedium()),
          const SizedBox(height: 4),
          Row(children: [const Icon(Icons.star, color: AppColors.starYellow, size: 12), const SizedBox(width: 4), Text('$rating  •  $distance', style: AppTextStyles.bodySmall(color: AppColors.textMedium))]),
          const SizedBox(height: 8),
          Row(children: tags.map((t) => Container(margin: const EdgeInsets.only(right: 8), padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: AppRadius.borderSM), child: Text(t, style: AppTextStyles.label(color: AppColors.primaryDark).copyWith(fontSize: 9, fontWeight: FontWeight.bold)))).toList()),
        ])),
        GestureDetector(
          onTap: () => ref.read(favoritesProvider.notifier).toggle(id),
          child: Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              color: isFav ? AppColors.errorText : AppColors.textMedium,
              size: 24,
            ),
          ),
        ),
        GestureDetector(
          onTap: () => context.push('${Routes.salonDetail}/$id'),
          child: Container(padding: const EdgeInsets.all(8), decoration: const BoxDecoration(color: AppColors.primaryDark, shape: BoxShape.circle), child: const Icon(Icons.arrow_forward, color: Colors.white, size: 18)),
        ),
      ]),
    );
  }
}