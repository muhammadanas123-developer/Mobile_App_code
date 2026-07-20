import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../shared/review_model.dart';

final ownerReviewsListProvider = StateNotifierProvider<OwnerReviewsListNotifier, List<ReviewModel>>((ref) {
  return OwnerReviewsListNotifier();
});

class OwnerReviewsListNotifier extends StateNotifier<List<ReviewModel>> {
  OwnerReviewsListNotifier()
      : super([
    ReviewModel(
      id: 'rev_1',
      reviewerName: 'Charlotte Dubois',
      rating: 5.0,
      comment: 'Absolutely amazing experience. The ai recommended Bio-Active Glow Facial was exactly what my dry skin needed. Sarah Jenkins was incredibly detailed and helpful!',
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
    ReviewModel(
      id: 'rev_2',
      reviewerName: 'Alice Mercier',
      rating: 4.0,
      comment: 'Very relaxing atmosphere and nice customer support. My hair highlight treatment was solid, although the slot started 10 minutes late.',
      date: DateTime.now().subtract(const Duration(days: 5)),
      replyContent: 'Thank you for your feedback, Alice! We strive to remain strictly on schedule and will make sure your next highlighting treatment starts right on time.',
    ),
    ReviewModel(
      id: 'rev_3',
      reviewerName: 'Julien Laurent',
      rating: 5.0,
      comment: 'Excellent deep tissue massage. volanic stones were perfectly heated. Solved my shoulder stiffness instantly. Highly recommend!',
      date: DateTime.now().subtract(const Duration(days: 8)),
    ),
  ]);

  void addReply(String reviewId, String reply) {
    state = state.map((rev) {
      if (rev.id == reviewId) {
        return ReviewModel(
          id: rev.id,
          reviewerName: rev.reviewerName,
          rating: rev.rating,
          comment: rev.comment,
          date: rev.date,
          replyContent: reply,
        );
      }
      return rev;
    }).toList();
  }
}

class OwnerReviewsTab extends ConsumerWidget {
  const OwnerReviewsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviews = ref.watch(ownerReviewsListProvider);

    // Calculate dynamic stats
    final averageRating = reviews.map((r) => r.rating).fold(0.0, (a, b) => a + b) / reviews.length;

    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surface,
      body: Column(
        children: [
          // Rating Summary Banner
          Container(
            color: AppColors.surface,
            padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Salon Rating',
                      style: AppTextStyles.titleMedium(color: AppColors.primaryDark),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          averageRating.toStringAsFixed(1),
                          style: AppTextStyles.metric(color: AppColors.primaryDark).copyWith(fontSize: 36),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '/ 5.0',
                          style: AppTextStyles.bodyMedium(color: AppColors.textLight),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < averageRating.floor() ? Icons.star : Icons.star_border,
                          color: AppColors.starYellow,
                          size: 20,
                        );
                      }),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Based on ${reviews.length} reviews',
                      style: AppTextStyles.bodySmall(color: AppColors.textMedium),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: AppColors.border),

          // Reviews List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: reviews.length,
              separatorBuilder: (context, index) => AppSpacing.gapMD,
              itemBuilder: (context, index) {
                final rev = reviews[index];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
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
                            rev.reviewerName,
                            style: AppTextStyles.titleMedium(),
                          ),
                          Text(
                            DateFormat('yyyy-MM-dd').format(rev.date),
                            style: AppTextStyles.bodySmall(color: AppColors.textLight),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: List.generate(5, (idx) {
                          return Icon(
                            idx < rev.rating.floor() ? Icons.star : Icons.star_border,
                            color: AppColors.starYellow,
                            size: 14,
                          );
                        }),
                      ),
                      AppSpacing.gapSM,
                      Text(
                        rev.comment,
                        style: AppTextStyles.bodyMedium(color: AppColors.textMedium).copyWith(height: 1.4),
                      ),

                      // Business Owner Reply (if exists)
                      if (rev.replyContent != null) ...[
                        Container(
                          margin: const EdgeInsets.only(top: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight.withValues(alpha: 0.25),
                            borderRadius: AppRadius.borderMD,
                            border: Border.all(color: AppColors.primaryAccent.withValues(alpha: 0.2)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Your Reply:',
                                style: AppTextStyles.label(color: AppColors.primaryDark).copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                rev.replyContent!,
                                style: AppTextStyles.bodyMedium(color: AppColors.textDark),
                              ),
                            ],
                          ),
                        ),
                      ] else ...[
                        // Reply action button
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: TextButton.icon(
                              onPressed: () => _showReplyDialog(context, ref, rev.id),
                              icon: const Icon(Icons.reply, size: 16, color: AppColors.primaryDark),
                              label: Text(
                                'Reply to Review',
                                style: AppTextStyles.bodySmall(color: AppColors.primaryDark).copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showReplyDialog(BuildContext context, WidgetRef ref, String reviewId) {
    final replyController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reply to Review'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Draft response as salon representative:'),
              const SizedBox(height: 12),
              TextField(
                controller: replyController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Type your message here...',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final replyText = replyController.text.trim();
                if (replyText.isNotEmpty) {
                  ref.read(ownerReviewsListProvider.notifier).addReply(reviewId, replyText);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Response posted!')),
                  );
                }
              },
              child: const Text('Post Reply'),
            ),
          ],
        );
      },
    );
  }
}