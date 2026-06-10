import 'package:flutter/material.dart';
import '../widgets/common_widgets.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Terms of Service'),
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
            _section('1. Acceptance of Terms',
                'By using the Fix-N-Go Technician App, you agree to these terms. If you disagree, discontinue use immediately.'),
            _section('2. Technician Obligations',
                'You must maintain valid KYC documentation, provide accurate skill information, complete accepted jobs professionally, and maintain a minimum rating of 3.5 stars.'),
            _section('3. Job Acceptance',
                'Once you accept a job, you are committed to completing it. Excessive cancellations may result in temporary suspension. You must arrive within the estimated time.'),
            _section('4. Payment Terms',
                'Earnings are credited to your wallet upon job completion. Withdrawals are processed within 1-2 business days. A platform fee of 15% is deducted from each job.'),
            _section('5. Equipment & Parts',
                'You are responsible for maintaining your own tools and sourcing quality replacement parts. Only genuine or certified parts should be used.'),
            _section('6. Customer Interaction',
                'Maintain professional conduct at all times. Harassment, discrimination, or unprofessional behavior will result in immediate account termination.'),
            _section('7. Liability',
                'Fix-N-Go is a platform connecting customers with technicians. You are an independent contractor, not an employee. You bear responsibility for the quality of your work.'),
            _section('8. Account Suspension',
                'Accounts may be suspended for: low ratings, excessive cancellations, customer complaints, fraudulent activity, or violation of these terms.'),
            _section('9. Dispute Resolution',
                'Disputes are handled through our support system. Unresolved issues are subject to arbitration under Indian law.'),
            _section('10. Modifications',
                'We reserve the right to modify these terms. Continued use after modifications constitutes acceptance.'),
            const SizedBox(height: 20),
            const Text(
              'Effective Date: January 1, 2026',
              style: TextStyle(color: AppColors.grey, fontSize: 12),
            ),
            const SizedBox(height: 8),
            const Text(
              'Fix-N-Go Private Limited, Hyderabad, India',
              style: TextStyle(color: AppColors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(String title, String body) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(body, style: const TextStyle(color: AppColors.greyLight, fontSize: 14, height: 1.6)),
        ],
      ),
    );
  }
}
