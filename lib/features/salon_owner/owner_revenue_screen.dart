import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';

class OwnerRevenueScreen extends StatelessWidget {
  const OwnerRevenueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock bar chart heights (percentages of 120 pixels max height)
    final weeklySales = [0.4, 0.6, 0.5, 0.8, 0.7, 0.95, 0.3]; // Mon-Sun
    final daysOfWeek = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    final payoutHistory = [
      {'date': 'July 01, 2026', 'amount': '€2,450.00', 'ref': 'BP-ai-90871', 'bank': 'Chase Checking (*8891)'},
      {'date': 'June 24, 2026', 'amount': '€2,120.00', 'ref': 'BP-ai-89712', 'bank': 'Chase Checking (*8891)'},
      {'date': 'June 17, 2026', 'amount': '€2,890.00', 'ref': 'BP-ai-88331', 'bank': 'Chase Checking (*8891)'},
    ];

    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: const Text('Revenue Analytics'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Net Earnings Overview
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryDark, Color(0xFF1B352B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: AppRadius.borderLG,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TOTAL REVENUE (THIS MONTH)',
                    style: AppTextStyles.label(color: AppColors.primaryAccent).copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '€29,800.00',
                    style: AppTextStyles.metric(color: AppColors.surface).copyWith(fontSize: 34),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMiniTextStat('Today', '€1,240.00'),
                      _buildMiniTextStat('This Week', '€7,450.00'),
                    ],
                  ),
                ],
              ),
            ),

            AppSpacing.gapLG,

            // Stylized Chart Card
            Card(
              elevation: 0,
              color: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.borderLG,
                side: const BorderSide(color: AppColors.border, width: 0.5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daily Sales Activity',
                      style: AppTextStyles.titleMedium(color: AppColors.primaryDark),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Mon, Jun 29 - Sun, Jul 05',
                      style: AppTextStyles.bodySmall(color: AppColors.textLight),
                    ),
                    const SizedBox(height: 24),

                    // Custom Container-based Bar Chart
                    SizedBox(
                      height: 140,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(weeklySales.length, (idx) {
                          final hFactor = weeklySales[idx];
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                width: 22,
                                height: 110 * hFactor,
                                decoration: BoxDecoration(
                                  color: idx == 5 ? AppColors.primaryDark : AppColors.primaryAccent,
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                daysOfWeek[idx],
                                style: AppTextStyles.label(
                                  color: idx == 5 ? AppColors.primaryDark : AppColors.textLight,
                                ).copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            AppSpacing.gapLG,

            // Payout logs
            Text(
              'Payout Withdrawals',
              style: AppTextStyles.titleLarge(),
            ),
            AppSpacing.gapSM,

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: payoutHistory.length,
              separatorBuilder: (context, index) => const Divider(color: AppColors.border),
              itemBuilder: (context, index) {
                final p = payoutHistory[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: AppColors.primaryLight,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.account_balance, color: AppColors.primaryDark, size: 20),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p['bank']!,
                              style: AppTextStyles.titleSmall(),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Ref: ${p['ref']!} • ${p['date']!}',
                              style: AppTextStyles.bodySmall(color: AppColors.textLight),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            p['amount']!,
                            style: AppTextStyles.titleMedium(color: AppColors.primaryDark).copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: AppColors.success,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'SENT',
                                style: AppTextStyles.label(color: AppColors.success).copyWith(fontSize: 8),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniTextStat(String title, String val) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.label(color: AppColors.primaryLight).copyWith(fontSize: 10),
        ),
        const SizedBox(height: 2),
        Text(
          val,
          style: AppTextStyles.titleMedium(color: AppColors.surface).copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}