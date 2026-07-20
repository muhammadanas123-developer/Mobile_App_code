import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/routing/routes.dart';
import '../../../shared/service_model.dart';
import 'package:fyp_project/features/booking/booking_state_provider.dart';

// ============ ADDED: Enums and Providers ============
enum AIScanState {
  idle,
  scanning,
  completed,
}

final aiScanStateProvider =
StateProvider<AIScanState>((ref) => AIScanState.idle);

final routineCheckboxProvider =
StateNotifierProvider<RoutineCheckboxNotifier, List<bool>>((ref) {
  return RoutineCheckboxNotifier();
});
// ============ END OF ADDED ============

class RoutineCheckboxNotifier extends StateNotifier<List<bool>> {
  RoutineCheckboxNotifier() : super([true, false, false, false]);

  void toggle(int index) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index) !state[i] else state[i]
    ];
  }
}

class AIHubTab extends ConsumerStatefulWidget {
  const AIHubTab({super.key});

  @override
  ConsumerState<AIHubTab> createState() => _AIHubTabState();
}

class _AIHubTabState extends ConsumerState<AIHubTab> with SingleTickerProviderStateMixin {
  late AnimationController _scannerAnimController;
  late Animation<double> _scanLineAnimation;
  Timer? _scanTimer;

  @override
  void initState() {
    super.initState();
    _scannerAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _scanLineAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scannerAnimController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scannerAnimController.dispose();
    _scanTimer?.cancel();
    super.dispose();
  }

  // ============ ADDED: _startScanning method ============
  void _startScanning() {
    ref.read(aiScanStateProvider.notifier).state = AIScanState.scanning;

    _scannerAnimController.repeat(reverse: true);

    _scanTimer = Timer(const Duration(seconds: 3), () {
      _scannerAnimController.stop();

      ref.read(aiScanStateProvider.notifier).state =
          AIScanState.completed;
    });
  }
  // ============ END OF ADDED ============

  @override
  Widget build(BuildContext context) {
    final scanState = ref.watch(aiScanStateProvider);

    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(scanState == AIScanState.completed ? Icons.arrow_back : Icons.menu),
          onPressed: () {
            if (scanState == AIScanState.completed) {
              ref.read(aiScanStateProvider.notifier).state = AIScanState.idle;
            }
          },
        ),
        title: const Text('Beauty Personalized by ai'),
        actions: [
          IconButton(icon: const Icon(Icons.share_outlined), onPressed: () {}),
          const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage(AppAssets.avatarUser),
            ),
          ),
        ],
      ),
      // ============ FIXED: Using AnimatedSwitcher with _buildBody ============
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _buildBody(scanState),
      ),
      // ============ END OF FIX ============
      floatingActionButton: scanState == AIScanState.idle
          ? FloatingActionButton(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: AppColors.surface,
        onPressed: () => context.push(Routes.aiChat),
        child: const Icon(Icons.chat_bubble_outline),
      )
          : null,
    );
  }

  // ============ FIXED: _buildBody with all cases and default return ============
  Widget _buildBody(AIScanState state) {
    switch (state) {
      case AIScanState.idle:
        return _buildLandingState();
      case AIScanState.scanning:
        return _buildScanningState();
      case AIScanState.completed:
        return _buildCompletedState();
      default:
        return _buildLandingState(); // Default fallback
    }
  }
  // ============ END OF FIX ============

  /// Screen 2 (New): Refined ai Hub Landing page
  Widget _buildLandingState() {
    final routineState = ref.watch(routineCheckboxProvider);

    return SingleChildScrollView(
      key: const ValueKey('idle'),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Next Gen Intelligence Banner
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primaryDark,
              borderRadius: AppRadius.borderLG,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight.withValues(alpha: 0.15),
                    borderRadius: AppRadius.borderSM,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.auto_awesome, color: AppColors.primaryAccent, size: 12),
                      const SizedBox(width: 4),
                      Text(
                        'NEXT-GEN INTELLIGENCE',
                        style: AppTextStyles.label(color: AppColors.primaryAccent).copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Start Your Professional ai Analysis',
                  style: AppTextStyles.titleLarge(color: AppColors.surface),
                ),
                const SizedBox(height: 8),
                Text(
                  'Scan your skin and hair in real-time to receive a personalized botanical treatment plan powered by deep-learning dermatology.',
                  style: AppTextStyles.bodySmall(color: AppColors.primaryLight).copyWith(
                    height: 1.45,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 20),

                // Open Scanner Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _startScanning, // ============ FIXED: Using _startScanning ============
                    icon: const Icon(Icons.qr_code_scanner_outlined, size: 18),
                    label: const Text('Open ai Scanner'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryAccent,
                      foregroundColor: AppColors.primaryDark,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      textStyle: AppTextStyles.button(color: AppColors.primaryDark),
                    ),
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.gapLG,

          // Intelligent Tools Grid Section
          Text(
            'Intelligent Tools',
            style: AppTextStyles.titleLarge(),
          ),
          AppSpacing.gapSM,

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.35,
            children: [
              _buildToolCard('Skin Analysis', 'Dermal health & hydration', Icons.face, () => context.push('${Routes.aiScan}?type=skin')),
              _buildToolCard('Hair Health', 'Scalp & strand integrity', Icons.content_cut, () => context.push('${Routes.aiScan}?type=hair')),
              _buildToolCard('Face Shape', 'Structure-based styling', Icons.filter_center_focus, () => context.push('${Routes.aiScan}?type=face_shape')),
              _buildToolCard('Makeup Try-on', 'AR virtual cosmetics', Icons.brush_outlined, () => context.push('${Routes.aiScan}?type=makeup')),
            ],
          ),
          AppSpacing.gapLG,

          // Daily Beauty Routine Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.cardBg.withValues(alpha: 0.5),
              borderRadius: AppRadius.borderLG,
              border: Border.all(color: AppColors.border, width: 0.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Daily Beauty Routine',
                      style: AppTextStyles.titleMedium(),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: AppRadius.borderSM,
                      ),
                      child: Text(
                        'ai Recommended',
                        style: AppTextStyles.label(color: AppColors.primaryDark).copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
                AppSpacing.gapMD,

                // Checklist
                _buildRoutineCheckbox(0, 'Botanical Cleansing Oil', 'Purify and hydrate (AM/PM)', routineState[0]),
                _buildRoutineCheckbox(1, 'Deep Sea Reviving Serum', 'Targeted hydration for mid-face', routineState[1]),
                _buildRoutineCheckbox(2, 'SPF 50+ Invisible Shield', 'Daily environmental protection', routineState[2]),
                _buildRoutineCheckbox(3, 'Night Repair Balm', 'Overnight renewal treatment', routineState[3]),
              ],
            ),
          ),
          AppSpacing.gapLG,

          // Skin Progress Container Card (dark green)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1B352B), // custom shade matching screen
              borderRadius: AppRadius.borderLG,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Skin Progress',
                      style: AppTextStyles.titleMedium(color: AppColors.surface),
                    ),
                    const Icon(Icons.show_chart, color: AppColors.primaryAccent, size: 22),
                  ],
                ),
                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'HEALTH SCORE',
                      style: AppTextStyles.label(color: AppColors.primaryLight).copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '88%',
                      style: AppTextStyles.metricSmall(color: AppColors.surface),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Progress Bar
                ClipRRect(
                  borderRadius: AppRadius.borderSM,
                  child: LinearProgressIndicator(
                    value: 0.88,
                    minHeight: 6,
                    backgroundColor: AppColors.surface.withValues(alpha: 0.15),
                    color: AppColors.primaryAccent,
                  ),
                ),
                const SizedBox(height: 16),

                // Droplet
                Row(
                  children: [
                    const Icon(Icons.water_drop, color: AppColors.primaryAccent, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'Hydration: +12% this week',
                      style: AppTextStyles.bodySmall(color: AppColors.surface).copyWith(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Texture
                Row(
                  children: [
                    const Icon(Icons.grid_3x3, color: AppColors.primaryAccent, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'Texture: Significantly smoother',
                      style: AppTextStyles.bodySmall(color: AppColors.surface).copyWith(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Button to jump straight to completed report
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      ref.read(aiScanStateProvider.notifier).state = AIScanState.completed;
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.surface.withValues(alpha: 0.15),
                      foregroundColor: AppColors.surface,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.borderMD),
                    ),
                    child: const Text('View Detailed Report'),
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.gapLG,

          // Analysis History horizontal list
          Text(
            'Analysis History',
            style: AppTextStyles.titleLarge(),
          ),
          AppSpacing.gapSM,

          SizedBox(
            height: 90,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildHistoryCard('Oct 12 Scan', 'FACE SHAPE', AppAssets.faceScan),
                const SizedBox(width: 16),
                _buildHistoryCard('Oct 24 Scan', 'HAIR HEALTH', AppAssets.faceScan),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolCard(String title, String subtitle, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.borderLG,
          border: Border.all(color: AppColors.border, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: AppColors.cardBg,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.primaryDark, size: 20),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.titleSmall(),
                ),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySmall(color: AppColors.textLight).copyWith(fontSize: 10),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoutineCheckbox(int index, String title, String subtitle, bool isChecked) {
    return GestureDetector(
      onTap: () => ref.read(routineCheckboxProvider.notifier).toggle(index),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isChecked ? AppColors.primaryDark : AppColors.surface,
                shape: BoxShape.circle,
                border: Border.all(color: isChecked ? AppColors.primaryDark : AppColors.border, width: 1.5),
              ),
              child: isChecked
                  ? const Icon(Icons.check, size: 14, color: AppColors.surface)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.titleSmall().copyWith(
                      decoration: isChecked ? TextDecoration.lineThrough : null,
                      color: isChecked ? AppColors.textLight : AppColors.textDark,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall(color: AppColors.textLight),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryCard(String date, String label, String imageAsset) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.borderMD,
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: AppRadius.borderSM,
            child: Image.asset(imageAsset, width: 44, height: 44, fit: BoxFit.cover),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  date,
                  style: AppTextStyles.label(color: AppColors.textLight).copyWith(fontSize: 10),
                ),
                Text(
                  label,
                  style: AppTextStyles.titleSmall().copyWith(fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============ ADDED: _buildScanningState method ============
  Widget _buildScanningState() {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
  // ============ END OF ADDED ============

  // ============ ADDED: _buildCompletedState method ============
  Widget _buildCompletedState() {
    return const Scaffold(
      body: Center(
        child: Text(
          'Analysis Complete',
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
  // ============ END OF ADDED ============

  Widget _buildOverlayChip(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        borderRadius: AppRadius.borderSM,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.success, size: 8),
          const SizedBox(width: 4),
          Text(
            text,
            style: AppTextStyles.label(color: AppColors.surface),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String val, String status, IconData icon, Color color, {bool isError = false}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.borderLG,
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: AppColors.textMedium, size: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isError ? AppColors.errorBg : AppColors.primaryLight,
                  borderRadius: AppRadius.borderSM,
                ),
                child: Text(
                  status,
                  style: AppTextStyles.label(color: isError ? AppColors.errorText : AppColors.primaryDark).copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.bodySmall(color: AppColors.textLight),
              ),
              Text(
                val,
                style: AppTextStyles.metricSmall(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationTag(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.1),
        borderRadius: AppRadius.borderSM,
        border: Border.all(color: AppColors.surface.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.primaryAccent, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.label(color: AppColors.surface),
          ),
        ],
      ),
    );
  }

  Widget _buildProductItem({
    required String brandName,
    required String productName,
    required double price,
    required String imageAsset,
  }) {
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
            child: Image.asset(imageAsset, width: 64, height: 64, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  brandName,
                  style: AppTextStyles.label(color: AppColors.textLight),
                ),
                Text(
                  productName,
                  style: AppTextStyles.titleMedium(),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${price.toStringAsFixed(2)}',
                  style: AppTextStyles.bodyMedium(color: AppColors.textMedium).copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_shopping_cart, color: AppColors.primaryDark),
            onPressed: () {},
            style: IconButton.styleFrom(
              backgroundColor: AppColors.cardBg,
            ),
          ),
        ],
      ),
    );
  }
}