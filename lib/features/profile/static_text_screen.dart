import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_spacing.dart';

class StaticTextScreen extends StatelessWidget {
  final String title;
  final String type; // 'privacy', 'terms', 'help'

  const StaticTextScreen({
    super.key,
    required this.title,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: Text(title),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _getContent(),
        ),
      ),
    );
  }

  List<Widget> _getContent() {
    if (type == 'privacy') {
      return [
        Text('Privacy Policy', style: AppTextStyles.h2(color: AppColors.primaryDark)),
        AppSpacing.gapSM,
        Text('Last updated: July 2026', style: AppTextStyles.bodySmall(color: AppColors.textLight)),
        AppSpacing.gapLG,
        _buildSectionHeader('1. Information We Collect'),
        _buildSectionBody(
          'We collect facial profile images and hair structure metrics solely for processing your personalized ai reports. These images are processed locally on device or securely analyzed and are never shared with third parties.',
        ),
        AppSpacing.gapMD,
        _buildSectionHeader('2. How We Use Information'),
        _buildSectionBody(
          'Your beauty metrics help us suggest appropriate botanical creams, facial treatment formulas, and book recommended local salons.',
        ),
        AppSpacing.gapMD,
        _buildSectionHeader('3. Security'),
        _buildSectionBody(
          'We apply high standard industry grade encryption protocols to safeguard your account info and saved billing card details.',
        ),
      ];
    } else if (type == 'terms') {
      return [
        Text('Terms & Conditions', style: AppTextStyles.h2(color: AppColors.primaryDark)),
        AppSpacing.gapSM,
        Text('Last updated: July 2026', style: AppTextStyles.bodySmall(color: AppColors.textLight)),
        AppSpacing.gapLG,
        _buildSectionHeader('1. License & Usage'),
        _buildSectionBody(
          'By downloading and using Beauty Personalized by ai, you agree to comply with our code of conduct and service guidelines.',
        ),
        AppSpacing.gapMD,
        _buildSectionHeader('2. Salon Bookings'),
        _buildSectionBody(
          'Appointments scheduled via this mobile application represent commitments with third-party salon providers. Cancellations must occur at least 24 hours prior to the scheduled slot.',
        ),
        AppSpacing.gapMD,
        _buildSectionHeader('3. Limitation of Liability'),
        _buildSectionBody(
          'ai scans and advice provide general guidelines. Consult certified dermatologists for skin medical conditions.',
        ),
      ];
    } else {
      // help center / FAQs
      return [
        Text('Help Center & FAQ', style: AppTextStyles.h2(color: AppColors.primaryDark)),
        AppSpacing.gapSM,
        Text('Find answers to common questions', style: AppTextStyles.bodySmall(color: AppColors.textLight)),
        AppSpacing.gapLG,
        _buildFAQItem(
          'How does the ai skin scanning work?',
          'Our deep-learning algorithms look at your skin\'s texture, hydration indicators, and color profile to map localized dry zones and suggest optimal treatments.',
        ),
        _buildFAQItem(
          'Are my images stored on a server?',
          'No, all capture viewfinders analyze features locally or use secure, ephemeral sessions. We do not store your raw images on our databases.',
        ),
        _buildFAQItem(
          'How do I cancel a booking?',
          'Go to the Bookings Tab, open the details of your upcoming booking, and select Cancel. Note the salon cancellation policy guidelines.',
        ),
      ];
    }
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppTextStyles.titleLarge(color: AppColors.textDark),
    );
  }

  Widget _buildSectionBody(String body) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        body,
        style: AppTextStyles.bodyMedium(color: AppColors.textMedium).copyWith(height: 1.5),
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: AppTextStyles.titleMedium(color: AppColors.textDark),
          ),
          const SizedBox(height: 6),
          Text(
            answer,
            style: AppTextStyles.bodyMedium(color: AppColors.textMedium).copyWith(height: 1.4),
          ),
          const Divider(height: 24, color: AppColors.border),
        ],
      ),
    );
  }
}