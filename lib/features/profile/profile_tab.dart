import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../authentication/presentation/auth_state_provider.dart';
import '../../../core/theme/app_theme_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';

/// ProfileTab provides account configuration, developer switches, and app configuration settings.
class ProfileTab extends ConsumerWidget {
  final bool isOwnerView;

  const ProfileTab({
    super.key,
    required this.isOwnerView,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authStateProvider);
    final themeMode = ref.watch(appThemeProvider);
    final user = auth.user;
    final isDark = themeMode == ThemeMode.dark;
    final textPrimary = isDark ? AppColors.surface : AppColors.textDark;
    final textSecondary = isDark ? const Color(0xFF8BA19B) : AppColors.textMedium;
    final textLight = isDark ? const Color(0xFF5A7A72) : AppColors.textLight;
    final borderColor = isDark ? const Color(0xFF1A3026) : AppColors.border;
    final cardBg = isDark ? const Color(0xFF14211A) : AppColors.surface;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F1713) : AppColors.background,
      appBar: AppBar(
        title: Text(
          'My Profile',
          style: TextStyle(color: isDark ? AppColors.surface : AppColors.textDark),
        ),
        elevation: 0,
        backgroundColor: isDark ? const Color(0xFF0F1713) : AppColors.background,
        iconTheme: IconThemeData(color: isDark ? AppColors.surface : AppColors.textDark),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // User Bio Header Card
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: AppRadius.borderLG,
                border: Border.all(color: borderColor, width: 0.5),
                boxShadow: isDark
                    ? []
                    : const [BoxShadow(color: AppColors.shadow, blurRadius: 10, offset: Offset(0, 4))],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: isDark ? const Color(0xFF1A3026) : AppColors.primaryLight,
                    backgroundImage: user?.avatarUrl != null
                        ? AssetImage(user!.avatarUrl!)
                        : null,
                    child: user?.avatarUrl == null
                        ? Icon(Icons.person, size: 36,
                        color: isDark ? AppColors.primaryAccent : AppColors.primaryDark)
                        : null,
                  ),
                  AppSpacing.gapMD,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name ?? 'Loading User...',
                          style: AppTextStyles.titleLarge().copyWith(color: textPrimary),
                        ),
                        AppSpacing.gapXXS,
                        Text(
                          user?.email ?? '---',
                          style: AppTextStyles.bodyMedium(color: textSecondary),
                        ),
                        AppSpacing.gapXS,
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1A3026) : AppColors.primaryLight,
                            borderRadius: AppRadius.borderSM,
                          ),
                          child: Text(
                            user?.role == 'owner' ? 'SALON OWNER' : 'MEMBER CLIENT',
                            style: AppTextStyles.label().copyWith(
                              color: isDark ? AppColors.primaryAccent : AppColors.primaryDark,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            AppSpacing.gapLG,

            // Developer Switcher Alert Box
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: (isDark ? AppColors.primaryAccent : AppColors.primaryDark).withValues(alpha: 0.08),
                borderRadius: AppRadius.borderMD,
                border: Border.all(
                  color: (isDark ? AppColors.primaryAccent : AppColors.primaryDark).withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Evaluate Experience',
                    style: AppTextStyles.titleSmall().copyWith(
                      color: isDark ? AppColors.primaryAccent : AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Switch roles to instantly experience the alternate dashboard and tabs.',
                    style: AppTextStyles.bodySmall().copyWith(color: textSecondary),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () => ref.read(authStateProvider.notifier).switchRole(),
                    icon: const Icon(Icons.swap_horizontal_circle),
                    label: Text(
                      user?.role == 'owner' ? 'Switch to Customer View' : 'Switch to Owner View',
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      textStyle: AppTextStyles.button().copyWith(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            AppSpacing.gapLG,

            // Options List
            Text(
              'SETTINGS & PREFERENCES',
              style: AppTextStyles.label().copyWith(color: textLight),
            ),
            AppSpacing.gapSM,

            // Theme toggle tile
            ListTile(
              leading: Icon(
                isDark ? Icons.dark_mode : Icons.light_mode,
                color: isDark ? AppColors.primaryAccent : AppColors.primaryDark,
              ),
              title: Text('Dark Theme', style: TextStyle(color: textPrimary)),
              trailing: Switch(
                value: isDark,
                activeTrackColor: isDark ? AppColors.primaryAccent : AppColors.primaryDark,
                activeThumbColor: Colors.white,
                onChanged: (_) => ref.read(appThemeProvider.notifier).toggleTheme(),
              ),
            ),
            Divider(color: borderColor, height: 1),

            if (!isOwnerView) ...[
              // Edit Profile
              ListTile(
                leading: const Icon(Icons.person_outline, color: AppColors.primaryDark),
                title: const Text('Edit Profile'),
                trailing: const Icon(Icons.chevron_right, color: AppColors.textLight),
                onTap: () => context.push('/customer/profile/edit'),
              ),
              const Divider(color: AppColors.border),

              // My Wallet
              ListTile(
                leading: const Icon(Icons.account_balance_wallet_outlined, color: AppColors.primaryDark),
                title: const Text('My Wallet'),
                trailing: const Icon(Icons.chevron_right, color: AppColors.textLight),
                onTap: () => context.push('/customer/wallet'),
              ),
              const Divider(color: AppColors.border),

              // Favorites
              ListTile(
                leading: const Icon(Icons.favorite_border, color: AppColors.primaryDark),
                title: const Text('Favorites & Saved'),
                trailing: const Icon(Icons.chevron_right, color: AppColors.textLight),
                onTap: () => context.push('/customer/profile/favorites'),
              ),
              const Divider(color: AppColors.border),
            ] else ...[
              // Business Revenue
              ListTile(
                leading: const Icon(Icons.insights, color: AppColors.primaryDark),
                title: const Text('Revenue Summary'),
                trailing: const Icon(Icons.chevron_right, color: AppColors.textLight),
                onTap: () => context.push('/owner/revenue'),
              ),
              const Divider(color: AppColors.border),

              // Customer Reviews
              ListTile(
                leading: const Icon(Icons.rate_review_outlined, color: AppColors.primaryDark),
                title: const Text('Customer Reviews'),
                trailing: const Icon(Icons.chevron_right, color: AppColors.textLight),
                onTap: () => context.push('/owner/reviews'),
              ),
              const Divider(color: AppColors.border),
            ],

            // Help Support Tile
            ListTile(
              leading: const Icon(Icons.help_outline, color: AppColors.primaryDark),
              title: const Text('Help Center & FAQs'),
              trailing: const Icon(Icons.chevron_right, color: AppColors.textLight),
              onTap: () => context.push('/customer/profile/page?title=Help%20Center&type=help'),
            ),
            const Divider(color: AppColors.border),

            // Privacy Policy Tile
            ListTile(
              leading: const Icon(Icons.security, color: AppColors.primaryDark),
              title: const Text('Privacy Policy'),
              trailing: const Icon(Icons.chevron_right, color: AppColors.textLight),
              onTap: () => context.push('/customer/profile/page?title=Privacy%20Policy&type=privacy'),
            ),
            const Divider(color: AppColors.border),

            // Terms Tile
            ListTile(
              leading: const Icon(Icons.description_outlined, color: AppColors.primaryDark),
              title: const Text('Terms & Conditions'),
              trailing: const Icon(Icons.chevron_right, color: AppColors.textLight),
              onTap: () => context.push('/customer/profile/page?title=Terms%20%26%20Conditions&type=terms'),
            ),
            const Divider(color: AppColors.border),

            // Logout
            ListTile(
              leading: const Icon(Icons.logout_rounded, color: AppColors.errorText),
              title: Text(
                'Log Out',
                style: AppTextStyles.titleMedium(color: AppColors.errorText),
              ),
              onTap: () => ref.read(authStateProvider.notifier).logout(),
            ),
          ],
        ),
      ),
    );
  }
}