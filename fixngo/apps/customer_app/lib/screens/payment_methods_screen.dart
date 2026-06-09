import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _methods = [
    {
      'type': 'cash',
      'label': 'Cash on Delivery',
      'icon': Icons.money_rounded,
      'color': AppColors.brandGreen,
    },
    {
      'type': 'upi',
      'label': 'UPI Payment',
      'icon': Icons.qr_code_rounded,
      'color': AppColors.brandBlue,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(
        backgroundColor: AppColors.bgDark,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.borderColor),
            ),
            child: const Icon(Icons.arrow_back_rounded,
                color: AppColors.textPrimary, size: 20),
          ),
        ),
        title: Text('Payment Methods',
            style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textWhite)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select default payment method',
                style: GoogleFonts.poppins(
                    fontSize: 14, color: AppColors.textSecondary)),
            const SizedBox(height: 16),
            ...List.generate(_methods.length, (i) {
              final m = _methods[i];
              final selected = i == _selectedIndex;
              return GestureDetector(
                onTap: () => setState(() => _selectedIndex = i),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.bgCard,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: selected
                          ? (m['color'] as Color)
                          : AppColors.borderColor,
                      width: selected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color:
                              (m['color'] as Color).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(m['icon'] as IconData,
                            color: m['color'] as Color, size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(m['label'] as String,
                            style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textWhite)),
                      ),
                      if (selected)
                        const Icon(Icons.check_circle_rounded,
                            color: AppColors.brandBlue, size: 22)
                      else
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: AppColors.textMuted, width: 1.5),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }),
            const Spacer(),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.bgCard,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.borderColor),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded,
                      color: AppColors.textMuted, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Online payment via Stripe will be available soon.',
                      style: GoogleFonts.poppins(
                          fontSize: 12, color: AppColors.textMuted),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
