import 'package:flutter/material.dart';

import '../widgets/common_widgets.dart';

class BankDetailsScreen extends StatefulWidget {
  const BankDetailsScreen({super.key});

  @override
  State<BankDetailsScreen> createState() => _BankDetailsScreenState();
}

class _BankDetailsScreenState extends State<BankDetailsScreen> {
  final _accNameCtrl = TextEditingController();
  final _accNumCtrl = TextEditingController();
  final _ifscCtrl = TextEditingController();
  final _bankNameCtrl = TextEditingController();
  final _upiCtrl = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _accNameCtrl.dispose();
    _accNumCtrl.dispose();
    _ifscCtrl.dispose();
    _bankNameCtrl.dispose();
    _upiCtrl.dispose();
    super.dispose();
  }

  void _save() {
    final messenger = ScaffoldMessenger.of(context);
    if (_accNumCtrl.text.trim().isEmpty || _ifscCtrl.text.trim().isEmpty) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Please fill required fields'), backgroundColor: AppColors.red),
      );
      return;
    }
    setState(() => _saving = true);
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() => _saving = false);
      messenger.showSnackBar(
        const SnackBar(content: Text('Bank details saved'), backgroundColor: AppColors.green),
      );
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Bank Details'),
        backgroundColor: AppColors.bg,
        foregroundColor: AppColors.white,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: Colors.white),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.red.withValues(alpha: 0.12), AppColors.red.withValues(alpha: 0.04)],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.red.withValues(alpha: 0.25)),
              ),
              child: Row(
                children: [
                  Icon(Icons.account_balance_rounded, color: AppColors.red, size: 32),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Withdrawal Account', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 4),
                        Text('Add your bank details to receive earnings.', style: TextStyle(color: AppColors.grey, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const SectionLabel('Bank Account'),
            _field('Account Holder Name', _accNameCtrl, Icons.person_outline_rounded),
            const SizedBox(height: 14),
            _field('Account Number', _accNumCtrl, Icons.numbers_rounded, keyboard: TextInputType.number),
            const SizedBox(height: 14),
            _field('IFSC Code', _ifscCtrl, Icons.code_rounded, caps: true),
            const SizedBox(height: 14),
            _field('Bank Name', _bankNameCtrl, Icons.account_balance_outlined),
            const SizedBox(height: 24),
            const SectionLabel('UPI (Optional)'),
            _field('UPI ID', _upiCtrl, Icons.qr_code_rounded),
            const SizedBox(height: 32),
            PrimaryButton(
              label: 'Save Bank Details',
              onTap: _save,
              isLoading: _saving,
              icon: Icons.save_rounded,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl, IconData icon,
      {TextInputType keyboard = TextInputType.text, bool caps = false}) {
    return TextField(
      controller: ctrl,
      keyboardType: keyboard,
      textCapitalization: caps ? TextCapitalization.characters : TextCapitalization.none,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.grey, fontSize: 13),
        prefixIcon: Icon(icon, color: AppColors.grey, size: 20),
      ),
    );
  }
}
