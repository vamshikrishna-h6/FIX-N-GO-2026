import 'package:flutter/material.dart';

import '../api_service_new.dart';
import '../widgets/common_widgets.dart';

class DocumentsKycScreen extends StatefulWidget {
  const DocumentsKycScreen({super.key});

  @override
  State<DocumentsKycScreen> createState() => _DocumentsKycScreenState();
}

class _DocumentsKycScreenState extends State<DocumentsKycScreen> {
  final _api = ApiService();
  bool _loading = true;
  Map<String, dynamic>? _profile;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final dash = await _api.getDashboard();
    if (!mounted) return;
    setState(() {
      _profile = dash;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final aadhaar = _profile?['aadhaarNumber'] as String?;
    final hasKyc = aadhaar != null && aadhaar.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Documents & KYC'),
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
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.red, strokeWidth: 2))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _statusCard(hasKyc),
                  const SizedBox(height: 24),
                  const SectionLabel('Aadhaar Verification'),
                  _docCard(
                    icon: Icons.credit_card_rounded,
                    title: 'Aadhaar Card',
                    subtitle: hasKyc ? 'XXXX XXXX ${aadhaar.substring(aadhaar.length - 4)}' : 'Not uploaded',
                    status: hasKyc ? 'Verified' : 'Pending',
                    statusColor: hasKyc ? AppColors.green : AppColors.yellow,
                  ),
                  const SizedBox(height: 14),
                  const SectionLabel('Other Documents'),
                  _docCard(
                    icon: Icons.badge_rounded,
                    title: 'ID Proof',
                    subtitle: 'Government-issued photo ID',
                    status: 'Optional',
                    statusColor: AppColors.grey,
                  ),
                  const SizedBox(height: 14),
                  _docCard(
                    icon: Icons.school_rounded,
                    title: 'Skill Certificate',
                    subtitle: 'Mobile repair certification',
                    status: 'Optional',
                    statusColor: AppColors.grey,
                  ),
                  const SizedBox(height: 24),
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
                        Icon(Icons.info_outline_rounded, color: AppColors.grey, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Documents are verified within 24 hours. You will be notified once verification is complete.',
                            style: TextStyle(color: AppColors.grey, fontSize: 12, height: 1.4),
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

  Widget _statusCard(bool verified) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: verified
              ? [AppColors.green.withValues(alpha: 0.15), AppColors.green.withValues(alpha: 0.05)]
              : [AppColors.yellow.withValues(alpha: 0.15), AppColors.yellow.withValues(alpha: 0.05)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: verified ? AppColors.green.withValues(alpha: 0.3) : AppColors.yellow.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            verified ? Icons.verified_rounded : Icons.pending_rounded,
            color: verified ? AppColors.green : AppColors.yellow,
            size: 36,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  verified ? 'KYC Verified' : 'KYC Pending',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  verified ? 'Your identity has been verified.' : 'Please upload your documents to get verified.',
                  style: TextStyle(color: AppColors.grey, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _docCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String status,
    required Color statusColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: statusColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: AppColors.grey, fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
