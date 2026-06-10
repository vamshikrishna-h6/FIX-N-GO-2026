import 'package:flutter/material.dart';

import '../widgets/common_widgets.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  static const List<Map<String, String>> _sections = [
    {
      'title': '1. Information We Collect',
      'body': 'We collect personal information you provide during registration including your name, email address, phone number, and Aadhaar details for KYC verification. We also collect location data to match you with nearby job requests, device information for analytics, and job performance data to maintain service quality.',
    },
    {
      'title': '2. How We Use Your Information',
      'body': 'Your information is used to connect you with customers needing repairs, process payments and track earnings, verify your identity and maintain platform trust, improve our services through analytics, and send relevant notifications about jobs, payments, and promotions.',
    },
    {
      'title': '3. Data Sharing',
      'body': 'We share your name, rating, and ETA with customers when you accept a job. We do not sell your personal information to third parties. Payment data is processed through secure, PCI-compliant payment partners. Aggregated, anonymized data may be used for business analytics.',
    },
    {
      'title': '4. Data Security',
      'body': 'We implement industry-standard security measures including encrypted data transmission (TLS/SSL), secure server infrastructure, regular security audits, and access controls for employee data access. Your Aadhaar information is encrypted at rest and in transit.',
    },
    {
      'title': '5. Location Data',
      'body': 'We collect your location while the app is in use to assign nearby jobs and calculate ETAs. You can control location access through your device settings. Disabling location may affect your ability to receive job requests.',
    },
    {
      'title': '6. Data Retention',
      'body': 'We retain your account data for as long as your account is active. Job history and earnings data are retained for 3 years for tax and audit purposes. You can request deletion of your account by contacting support.',
    },
    {
      'title': '7. Your Rights',
      'body': 'You have the right to access your personal data, correct inaccurate information, request deletion of your account, opt out of promotional communications, and file a complaint with the relevant data protection authority.',
    },
    {
      'title': '8. Contact Us',
      'body': 'For privacy-related questions, contact us at:\nEmail: privacy@fixngo.in\nPhone: +91 98765 43210\nAddress: Fix-N-Go Technologies, Hyderabad, India',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Privacy Policy'),
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
                  Icon(Icons.policy_rounded, color: AppColors.red, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Fix-N-Go Privacy Policy', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
                        const SizedBox(height: 4),
                        Text('Last updated: June 2026', style: TextStyle(color: AppColors.grey, fontSize: 12)),
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
