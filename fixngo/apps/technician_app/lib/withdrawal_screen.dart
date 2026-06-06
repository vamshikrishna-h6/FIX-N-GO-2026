import 'package:flutter/material.dart';

import 'api_service_new.dart';
import 'widgets/common_widgets.dart';

class WithdrawalScreen extends StatefulWidget {
  const WithdrawalScreen({super.key});

  @override
  State<WithdrawalScreen> createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> {
  final _api = ApiService();
  final _amountCtrl = TextEditingController();
  final _bankCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _amountCtrl.dispose();
    _bankCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final amount = int.tryParse(_amountCtrl.text.trim()) ?? 0;
    if (amount <= 0 || _bankCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid amount and bank account'), backgroundColor: AppColors.red),
      );
      return;
    }

    setState(() => _loading = true);
    final success = await _api.requestWithdrawal(amount, _bankCtrl.text.trim());
    if (!mounted) return;
    setState(() => _loading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Withdrawal requested successfully!'), backgroundColor: AppColors.green),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Withdrawal request failed'), backgroundColor: AppColors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Withdraw Funds'),
        backgroundColor: AppColors.bg,
        foregroundColor: AppColors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SectionLabel('Amount'),
              TextField(
                controller: _amountCtrl,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Enter amount',
                  prefixIcon: Icon(Icons.currency_rupee_rounded),
                ),
              ),
              const SizedBox(height: 16),
              const SectionLabel('Bank Account'),
              TextField(
                controller: _bankCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Bank account number',
                  prefixIcon: Icon(Icons.account_balance_rounded),
                ),
              ),
              const Spacer(),
              PrimaryButton(
                label: 'Request Withdrawal',
                isLoading: _loading,
                color: AppColors.green,
                icon: Icons.payments_rounded,
                onTap: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}