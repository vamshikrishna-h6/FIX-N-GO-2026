import 'package:flutter/material.dart';
import '../widgets/common_widgets.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Privacy Policy'),
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
            _section('1. Information We Collect',
                'We collect information you provide directly, including name, email, phone number, Aadhaar details for KYC, location data, device information, and service history.'),
            _section('2. How We Use Your Information',
                'Your information is used to match you with repair requests, process payments, verify your identity, improve our services, and communicate important updates about your account.'),
            _section('3. Location Data',
                'We collect precise GPS location when you are online to match you with nearby repair requests. Location is not tracked when you are offline.'),
            _section('4. Data Sharing',
                'We share limited information with customers (name, rating, estimated arrival) for active bookings. We do not sell your personal data to third parties.'),
            _section('5. Data Security',
                'We employ industry-standard encryption and security measures to protect your data. All API communications are encrypted via TLS/SSL.'),
            _section('6. Data Retention',
                'We retain your data for as long as your account is active. You may request data deletion by contacting support.'),
            _section('7. Your Rights',
                'You have the right to access, correct, or delete your personal data. Contact support@fixngo.in to exercise these rights.'),
            _section('8. Changes to Policy',
                'We may update this policy periodically. Significant changes will be notified through the app.'),
            const SizedBox(height: 20),
            const Text(
              'Last updated: June 2026',
              style: TextStyle(color: AppColors.grey, fontSize: 12),
            ),
            const SizedBox(height: 8),
            const Text(
              'Contact: privacy@fixngo.in',
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
