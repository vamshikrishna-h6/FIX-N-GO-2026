import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../widgets/common_widgets.dart';

class BankDetailsScreen extends StatefulWidget {
  const BankDetailsScreen({super.key});

  @override
  State<BankDetailsScreen> createState() => _BankDetailsScreenState();
}

class _BankDetailsScreenState extends State<BankDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _accountNameCtrl = TextEditingController();
  final _accountNumberCtrl = TextEditingController();
  final _ifscCtrl = TextEditingController();
  final _bankNameCtrl = TextEditingController();
  final _upiCtrl = TextEditingController();
  bool _loading = true;
  bool _saving = false;
  bool _hasSaved = false;

  @override
  void initState() {
    super.initState();
    _loadBankDetails();
  }

  @override
  void dispose() {
    _accountNameCtrl.dispose();
    _accountNumberCtrl.dispose();
    _ifscCtrl.dispose();
    _bankNameCtrl.dispose();
    _upiCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadBankDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('bank_details');
    if (data != null) {
      final details = jsonDecode(data) as Map<String, dynamic>;
      _accountNameCtrl.text = details['accountName'] ?? '';
      _accountNumberCtrl.text = details['accountNumber'] ?? '';
      _ifscCtrl.text = details['ifsc'] ?? '';
      _bankNameCtrl.text = details['bankName'] ?? '';
      _upiCtrl.text = details['upiId'] ?? '';
      _hasSaved = true;
    }
    setState(() => _loading = false);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('bank_details', jsonEncode({
      'accountName': _accountNameCtrl.text.trim(),
      'accountNumber': _accountNumberCtrl.text.trim(),
      'ifsc': _ifscCtrl.text.trim(),
      'bankName': _bankNameCtrl.text.trim(),
      'upiId': _upiCtrl.text.trim(),
    }));

    if (!mounted) return;
    setState(() {
      _saving = false;
      _hasSaved = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Bank details saved'), backgroundColor: AppColors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Bank Details'),
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
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.red, strokeWidth: 2))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_hasSaved)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: AppColors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.green.withValues(alpha: 0.3)),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.check_circle_rounded, color: AppColors.green, size: 20),
                            SizedBox(width: 10),
                            Text('Bank details saved', style: TextStyle(color: AppColors.green, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    const SectionLabel('Account Holder Name'),
                    TextFormField(
                      controller: _accountNameCtrl,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Full name as per bank',
                        prefixIcon: Icon(Icons.person_outline_rounded),
                      ),
                      validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    const SectionLabel('Account Number'),
                    TextFormField(
                      controller: _accountNumberCtrl,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Bank account number',
                        prefixIcon: Icon(Icons.account_balance_rounded),
                      ),
                      validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    const SectionLabel('IFSC Code'),
                    TextFormField(
                      controller: _ifscCtrl,
                      style: const TextStyle(color: Colors.white),
                      textCapitalization: TextCapitalization.characters,
                      decoration: const InputDecoration(
                        hintText: 'e.g. SBIN0001234',
                        prefixIcon: Icon(Icons.code_rounded),
                      ),
                      validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    const SectionLabel('Bank Name'),
                    TextFormField(
                      controller: _bankNameCtrl,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'e.g. State Bank of India',
                        prefixIcon: Icon(Icons.business_rounded),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const SectionLabel('UPI ID (Optional)'),
                    TextFormField(
                      controller: _upiCtrl,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'yourname@upi',
                        prefixIcon: Icon(Icons.qr_code_rounded),
                      ),
                    ),
                    const SizedBox(height: 32),
                    PrimaryButton(
                      label: 'Save Bank Details',
                      isLoading: _saving,
                      color: AppColors.green,
                      icon: Icons.save_rounded,
                      onTap: _save,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
