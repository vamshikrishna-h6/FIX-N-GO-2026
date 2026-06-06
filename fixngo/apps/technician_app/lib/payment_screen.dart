import 'package:flutter/material.dart';

import 'api_service_new.dart';
import 'widgets/common_widgets.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen>
    with TickerProviderStateMixin {
  final _api = ApiService();
  String _selectedMethod = 'upi';
  bool _loading = false;
  bool _success = false;
  Map<String, dynamic>? _job;
  late AnimationController _successCtrl;
  late Animation<double> _successScale;

  @override
  void initState() {
    super.initState();
    _successCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _successScale = CurvedAnimation(parent: _successCtrl, curve: Curves.elasticOut);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map<String, dynamic>) {
      _job = args;
    }
  }

  @override
  void dispose() {
    _successCtrl.dispose();
    super.dispose();
  }

  Future<void> _confirmPayment() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (_job?['_id'] != null) {
      await _api.completeJob(_job!['_id']);
    }
    if (!mounted) return;
    setState(() {
      _loading = false;
      _success = true;
    });
    _successCtrl.forward();
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    final price = _job?['estimatedPrice'] ?? 499;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
              color: Colors.white,
            ),
          ),
        ),
        title: const Text('Collect Payment'),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.green.withValues(alpha: 0.15),
                          AppColors.green.withValues(alpha: 0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.green.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Amount to Collect',
                          style: TextStyle(color: AppColors.grey, fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '₹$price',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 48,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Service completed • Collect now',
                          style: TextStyle(color: AppColors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  const SectionLabel('Payment Method'),
                  _paymentOption(
                    'upi',
                    Icons.qr_code_rounded,
                    'UPI / QR Code',
                    'Google Pay, PhonePe, Paytm',
                    AppColors.orange,
                  ),
                  const SizedBox(height: 10),
                  _paymentOption(
                    'cash',
                    Icons.payments_rounded,
                    'Cash',
                    'Collect cash directly',
                    AppColors.green,
                  ),
                  const SizedBox(height: 28),
                  if (_selectedMethod == 'upi') ...[
                    GlassCard(
                      child: Column(
                        children: [
                          const Text(
                            'Show this QR to customer',
                            style: TextStyle(color: AppColors.grey, fontSize: 13),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            width: 180,
                            height: 180,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.qr_code_2_rounded, size: 120, color: Colors.black),
                                  SizedBox(height: 4),
                                  Text(
                                    'fixer@upi',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'UPI ID: fixer@ybl',
                            style: TextStyle(color: AppColors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                  ],
                  if (_selectedMethod == 'cash') ...[
                    GlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.info_outline_rounded, color: AppColors.yellow, size: 18),
                              SizedBox(width: 8),
                              Text(
                                'Cash Collection Tips',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _tip('Collect exact amount ₹$price'),
                          _tip('Provide receipt to customer'),
                          _tip('Deposit to wallet within 24 hours'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                  ],
                  PrimaryButton(
                    label: 'Confirm Payment Received',
                    onTap: _confirmPayment,
                    isLoading: _loading,
                    color: AppColors.green,
                    icon: Icons.check_circle_rounded,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          if (_success)
            Positioned.fill(
              child: Container(
                color: AppColors.bg.withValues(alpha: 0.9),
                child: Center(
                  child: ScaleTransition(
                    scale: _successScale,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: AppColors.green,
                            shape: BoxShape.circle,
                            boxShadow: AppShadows.green,
                          ),
                          child: const Icon(Icons.check_rounded, color: Colors.white, size: 56),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Payment Collected!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Job completed successfully',
                          style: TextStyle(color: AppColors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _paymentOption(String value, IconData icon, String title, String subtitle, Color color) {
    final selected = _selectedMethod == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.08) : AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? color : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(color: AppColors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? color : Colors.transparent,
                border: Border.all(
                  color: selected ? color : AppColors.grey,
                  width: 1.5,
                ),
              ),
              child: selected
                  ? const Icon(Icons.check_rounded, color: Colors.white, size: 14)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _tip(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.arrow_right_rounded, color: AppColors.yellow, size: 16),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: AppColors.greyLight, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}