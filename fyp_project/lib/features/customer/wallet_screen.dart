import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../shared/transaction_model.dart';

final walletBalanceProvider = StateProvider<double>((ref) => 248.50);

final transactionsProvider = StateNotifierProvider<TransactionsNotifier, List<TransactionModel>>((ref) {
  return TransactionsNotifier();
});

class TransactionsNotifier extends StateNotifier<List<TransactionModel>> {
  TransactionsNotifier()
      : super([
    TransactionModel(
      id: 'tx_1',
      title: 'Botanical Glow Facial - Maison de Beauté',
      dateTime: DateTime.now().subtract(const Duration(days: 1)),
      amount: 145.00,
      type: 'debit',
      status: 'completed',
    ),
    TransactionModel(
      id: 'tx_2',
      title: 'Wallet Top-up (Visa ***4242)',
      dateTime: DateTime.now().subtract(const Duration(days: 3)),
      amount: 200.00,
      type: 'credit',
      status: 'completed',
    ),
    TransactionModel(
      id: 'tx_3',
      title: 'Nail Art Polish - Maison de Beauté',
      dateTime: DateTime.now().subtract(const Duration(days: 7)),
      amount: 55.00,
      type: 'debit',
      status: 'completed',
    ),
  ]);

  void addTransaction(TransactionModel tx) {
    state = [tx, ...state];
  }
}

class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balance = ref.watch(walletBalanceProvider);
    final transactions = ref.watch(transactionsProvider);

    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: const Text('My Wallet'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Premium Card Visual
            Container(
              height: 200,
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF1B3B2B), // Forest Green
                    Color(0xFF2A5C43), // Lighter Tealish Green
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: AppRadius.borderLG,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1B3B2B).withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Beauty Personalized by ai',
                        style: AppTextStyles.label(color: AppColors.primaryAccent).copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const Icon(Icons.nfc, color: AppColors.primaryAccent, size: 24),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TOTAL BALANCE',
                        style: AppTextStyles.label(color: AppColors.primaryLight).copyWith(
                          fontSize: 10,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${balance.toStringAsFixed(2)}',
                        style: AppTextStyles.metric(color: AppColors.surface).copyWith(fontSize: 32),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '•••• •••• •••• 4242',
                        style: AppTextStyles.bodyMedium(color: AppColors.surface).copyWith(
                          letterSpacing: 2,
                        ),
                      ),
                      Text(
                        '12/28',
                        style: AppTextStyles.bodySmall(color: AppColors.primaryLight),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            AppSpacing.gapLG,

            // Quick Operations Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showAddMoneyDialog(context, ref),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Top Up'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryDark,
                      foregroundColor: AppColors.surface,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.borderMD),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showCardsSheet(context),
                    icon: const Icon(Icons.credit_card, size: 18),
                    label: const Text('Cards'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.surface,
                      foregroundColor: AppColors.primaryDark,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.borderMD),
                    ),
                  ),
                ),
              ],
            ),

            AppSpacing.gapXL,

            // Transactions History title
            Text(
              'Recent Transactions',
              style: AppTextStyles.titleLarge(),
            ),
            AppSpacing.gapSM,

            // Ledger List
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: transactions.length,
              separatorBuilder: (context, index) => const Divider(color: AppColors.border),
              itemBuilder: (context, index) {
                final tx = transactions[index];
                final isCredit = tx.type == 'credit';

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isCredit ? AppColors.primaryLight : AppColors.cardBg,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isCredit ? Icons.arrow_downward : Icons.shopping_bag_outlined,
                          color: isCredit ? AppColors.primaryDark : AppColors.textMedium,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tx.title,
                              style: AppTextStyles.titleSmall(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              DateFormat('MMM dd, yyyy • hh:mm a').format(tx.dateTime),
                              style: AppTextStyles.bodySmall(color: AppColors.textLight),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${isCredit ? "+" : "-"}\$${tx.amount.toStringAsFixed(2)}',
                            style: AppTextStyles.titleMedium(
                              color: isCredit ? AppColors.primaryDark : AppColors.textDark,
                            ).copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: AppRadius.borderSM,
                            ),
                            child: Text(
                              tx.status.toUpperCase(),
                              style: AppTextStyles.label(color: AppColors.primaryDark).copyWith(fontSize: 8),
                            ),
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

  void _showAddMoneyDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController(text: '50');
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Top Up Wallet'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Enter amount to load into your wallet balance:'),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  prefixText: '\$',
                  hintText: 'Enter amount',
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
                final amt = double.tryParse(controller.text) ?? 0.0;
                if (amt > 0) {
                  ref.read(walletBalanceProvider.notifier).update((s) => s + amt);
                  ref.read(transactionsProvider.notifier).addTransaction(
                    TransactionModel(
                      id: 'tx_user_${DateTime.now().millisecondsSinceEpoch}',
                      title: 'Wallet Load (Visa ***4242)',
                      dateTime: DateTime.now(),
                      amount: amt,
                      type: 'credit',
                      status: 'completed',
                    ),
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Successfully loaded \$${amt.toStringAsFixed(2)}!')),
                  );
                }
              },
              child: const Text('Add Cash'),
            ),
          ],
        );
      },
    );
  }

  void _showCardsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Payment Methods',
                style: AppTextStyles.h2(),
              ),
              AppSpacing.gapMD,
              ListTile(
                leading: const Icon(Icons.credit_card, color: AppColors.primaryDark),
                title: const Text('Visa ending in 4242'),
                subtitle: const Text('Expires 12/28 • Default'),
                trailing: const Icon(Icons.check_circle, color: AppColors.primaryDark),
                onTap: () {},
              ),
              const Divider(color: AppColors.border),
              ListTile(
                leading: const Icon(Icons.credit_card, color: AppColors.textMedium),
                title: const Text('MasterCard ending in 9876'),
                subtitle: const Text('Expires 08/29'),
                trailing: IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {},
                ),
                onTap: () {},
              ),
              AppSpacing.gapLG,
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Add card integration flow (UI only)')),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add New Card'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}