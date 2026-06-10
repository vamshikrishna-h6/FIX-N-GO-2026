import 'package:flutter/material.dart';

import '../widgets/common_widgets.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  static const List<Map<String, String>> _sections = [
    {
      'title': '1. Acceptance of Terms',
      'body': 'By registering as a technician on the Fix-N-Go platform, you agree to be bound by these Terms of Service. If you do not agree, please do not use our services. We may update these terms from time to time and will notify you of significant changes.',
    },
    {
      'title': '2. Eligibility',
      'body': 'You must be at least 18 years old, possess valid government-issued identification (Aadhaar), have relevant mobile repair skills, and pass our background verification process to use the platform as a technician partner.',
    },
    {
      'title': '3. Technician Responsibilities',
      'body': 'As a Fix-N-Go technician, you agree to: maintain a professional demeanor with customers, arrive at job locations on time, provide quality repair services, use genuine parts when available, accurately report job status and completion, and maintain your tools and equipment.',
    },
    {
      'title': '4. Job Acceptance & Cancellation',
      'body': 'You may accept or decline job requests. Once accepted, cancellations should be avoided. Excessive cancellations (more than 15% cancellation rate) may result in temporary suspension. Emergency cancellations must be reported at least 10 minutes before the scheduled time.',
    },
    {
      'title': '5. Payments & Earnings',
      'body': 'Earnings are credited to your wallet upon job completion. Fix-N-Go charges a platform commission of 15-20% per job. Withdrawals to your bank account are processed within 1-2 business days. Minimum withdrawal amount is \u20B9100. All earnings are subject to applicable taxes.',
    },
    {
      'title': '6. Rating System',
      'body': 'Your performance is measured through customer ratings. A minimum average rating of 4.0 is required to remain active on the platform. Ratings below 3.5 may result in temporary deactivation. You can improve your rating by delivering quality service and maintaining professionalism.',
    },
    {
      'title': '7. Account Suspension',
      'body': 'Fix-N-Go reserves the right to suspend or terminate accounts for: fraudulent activity, consistently poor ratings, violation of these terms, customer complaints of misconduct, or providing false information during registration.',
    },
    {
      'title': '8. Liability',
      'body': 'Fix-N-Go acts as a platform connecting technicians with customers. We are not responsible for damages arising from repair services. Technicians are expected to carry appropriate insurance and liability coverage for their work.',
    },
    {
      'title': '9. Dispute Resolution',
      'body': 'Disputes between technicians and customers will first be mediated by Fix-N-Go support. If unresolved, disputes shall be subject to arbitration under Indian Arbitration Act in the jurisdiction of Hyderabad, India.',
    },
    {
      'title': '10. Contact',
      'body': 'For questions about these terms:\nEmail: legal@fixngo.in\nPhone: +91 98765 43210\nAddress: Fix-N-Go Technologies, Hyderabad, India',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Terms of Service'),
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
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Icon(Icons.gavel_rounded, color: AppColors.red, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Fix-N-Go Terms of Service', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
                        const SizedBox(height: 4),
                        Text('Effective: June 2026', style: TextStyle(color: AppColors.grey, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ..._sections.map((s) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s['title']!,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    s['body']!,
                    style: TextStyle(color: AppColors.grey, fontSize: 13, height: 1.6),
                  ),
                ],
              ),
            )),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
