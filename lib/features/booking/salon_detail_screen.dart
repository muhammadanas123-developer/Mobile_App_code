import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/salons_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/routing/routes.dart';
import 'booking_state_provider.dart';

class SalonDetailScreen extends ConsumerStatefulWidget {
  final String salonId;

  const SalonDetailScreen({super.key, required this.salonId});

  @override
  ConsumerState<SalonDetailScreen> createState() => _SalonDetailScreenState();
}

class _SalonDetailScreenState extends ConsumerState<SalonDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final salons = ref.watch(salonsProvider);
    final salon = salons.firstWhere((s) => s.id == widget.salonId, orElse: () => salons.first);

    return Scaffold(
      backgroundColor: cs.surface,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                Image.asset(salon.imageUrl, height: 320, width: double.infinity, fit: BoxFit.cover),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white.withValues(alpha: 0.9),
                          child: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.textDark), onPressed: () => context.pop()),
                        ),
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.white.withValues(alpha: 0.9),
                              child: IconButton(icon: const Icon(Icons.share_outlined, color: AppColors.textDark), onPressed: () {}),
                            ),
                            const SizedBox(width: 12),
                            CircleAvatar(
                              backgroundColor: Colors.white.withValues(alpha: 0.9),
                              child: IconButton(icon: const Icon(Icons.favorite_border, color: AppColors.textDark), onPressed: () {}),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 24, left: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.95),
                      borderRadius: AppRadius.borderLG,
                      boxShadow: const [BoxShadow(color: AppColors.shadow, blurRadius: 10)],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.star, color: AppColors.starYellow, size: 18),
                            const SizedBox(width: 4),
                            Text('${salon.rating} (${salon.reviewsCount} Reviews)', style: AppTextStyles.titleMedium(color: AppColors.textDark)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text('${salon.category} • ${salon.city}', style: AppTextStyles.label(color: AppColors.textMedium)),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            Container(color: cs.surface, child: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.primaryDark,
              labelColor: AppColors.primaryDark,
              unselectedLabelColor: AppColors.textLight,
              labelStyle: AppTextStyles.titleSmall(),
              tabs: const [
                Tab(text: 'Services'), Tab(text: 'Staff'), Tab(text: 'Reviews'), Tab(text: 'About'),
              ],
            )),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTabContent(salon),
                  AppSpacing.gapXL,
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (salon.services.isNotEmpty) ref.read(selectedServiceProvider.notifier).state = salon.services.first;
                        context.push(Routes.bookingFlow);
                      },
                      icon: const Icon(Icons.calendar_month),
                      label: const Text('Book Treatment'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryDark,
                        foregroundColor: AppColors.surface,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(salon) {
    switch (_tabController.index) {
      case 0: return _buildServicesTab(salon);
      case 1: return _buildStaffTab();
      case 2: return _buildReviewsTab();
      case 3: default: return _buildAboutTab(salon);
    }
  }

  Widget _buildServicesTab(salon) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Popular Services', style: AppTextStyles.titleLarge()),
        AppSpacing.gapSM,
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: salon.services.length,
          separatorBuilder: (context, index) => AppSpacing.gapMD,
          itemBuilder: (context, index) {
            final service = salon.services[index];
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: AppRadius.borderLG,
                border: Border.all(color: AppColors.border, width: 0.5),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(service.name, style: AppTextStyles.titleLarge()),
                        const SizedBox(height: 6),
                        Text(service.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: AppTextStyles.bodyMedium(color: AppColors.textMedium)),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Text('${service.durationMinutes} min', style: AppTextStyles.bodySmall(color: AppColors.textLight).copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(width: 16),
                            Text('Rs ${service.price.toStringAsFixed(0)}', style: AppTextStyles.bodyMedium(color: AppColors.textDark).copyWith(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(selectedServiceProvider.notifier).state = service;
                      context.push(Routes.bookingFlow);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryDark, foregroundColor: AppColors.surface,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.borderMD),
                    ),
                    child: const Text('Book\nNow', textAlign: TextAlign.center),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildStaffTab() {
    final cs = Theme.of(context).colorScheme;
    final staff = [
      {'name': 'Ayesha Khan', 'role': 'Senior Esthetician', 'rating': '4.9'},
      {'name': 'Bilal Ahmed', 'role': 'Massage Specialist', 'rating': '4.8'},
      {'name': 'Hira Tariq', 'role': 'Nail Artist', 'rating': '4.7'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Meet Our Specialists', style: AppTextStyles.titleLarge()),
        AppSpacing.gapSM,
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 0.95),
          itemCount: staff.length,
          itemBuilder: (context, index) {
            final member = staff[index];
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: cs.surface, borderRadius: AppRadius.borderLG, border: Border.all(color: AppColors.border, width: 0.5)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(radius: 32, backgroundColor: AppColors.primaryLight, child: Icon(Icons.person, color: AppColors.primaryDark, size: 32)),
                  const SizedBox(height: 10),
                  Text(member['name']!, style: AppTextStyles.titleSmall(), textAlign: TextAlign.center),
                  Text(member['role']!, style: AppTextStyles.bodySmall(color: AppColors.textMedium), textAlign: TextAlign.center),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star, color: AppColors.starYellow, size: 12),
                      const SizedBox(width: 4),
                      Text(member['rating']!, style: AppTextStyles.label().copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildReviewsTab() {
    final cs = Theme.of(context).colorScheme;
    final reviews = [
      {'name': 'Fatima Noor', 'comment': 'The herbal facial was incredible. My skin feels so soft and glowing!', 'rating': 5, 'date': '2 days ago'},
      {'name': 'Zainab Ali', 'comment': 'Very clean setup and professional staff. The balayage turned out beautiful!', 'rating': 4, 'date': '1 week ago'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Customer Feedback', style: AppTextStyles.titleLarge()),
        AppSpacing.gapSM,
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: reviews.length,
          separatorBuilder: (context, index) => AppSpacing.gapSM,
          itemBuilder: (context, index) {
            final rev = reviews[index];
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: cs.surface, borderRadius: AppRadius.borderLG, border: Border.all(color: AppColors.border, width: 0.5)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text(rev['name'] as String, style: AppTextStyles.titleSmall()), Text(rev['date'] as String, style: AppTextStyles.bodySmall(color: AppColors.textLight))],
                  ),
                  const SizedBox(height: 4),
                  Row(children: List.generate(5, (idx) => Icon(idx < (rev['rating'] as int) ? Icons.star : Icons.star_border, color: AppColors.starYellow, size: 14))),
                  const SizedBox(height: 8),
                  Text(rev['comment'] as String, style: AppTextStyles.bodyMedium(color: AppColors.textMedium)),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAboutTab(salon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('About the Salon', style: AppTextStyles.titleLarge()),
        AppSpacing.gapSM,
        Text(salon.description, style: AppTextStyles.bodyMedium(color: AppColors.textMedium).copyWith(height: 1.45)),
        AppSpacing.gapLG,
        Text('Location & Contacts', style: AppTextStyles.titleLarge()),
        AppSpacing.gapSM,
        Row(children: [const Icon(Icons.location_on_outlined, color: AppColors.primaryDark, size: 20), const SizedBox(width: 8), Expanded(child: Text(salon.address, style: AppTextStyles.bodyMedium()))]),
        const SizedBox(height: 8),
        Row(children: [const Icon(Icons.phone_outlined, color: AppColors.primaryDark, size: 20), const SizedBox(width: 8), Text('+92 42 3571 2345', style: AppTextStyles.bodyMedium())]),
        AppSpacing.gapLG,
        Container(
          height: 140,
          decoration: BoxDecoration(color: AppColors.primaryLight.withValues(alpha: 0.3), borderRadius: AppRadius.borderMD, border: Border.all(color: AppColors.primaryAccent.withValues(alpha: 0.3))),
          child: const Center(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.map, color: AppColors.primaryDark), SizedBox(width: 8), Text('Map view placeholder (UI only)', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.bold))])),
        ),
      ],
    );
  }
}