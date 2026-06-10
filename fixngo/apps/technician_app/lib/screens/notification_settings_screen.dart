import 'package:flutter/material.dart';

import '../widgets/common_widgets.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _jobAlerts = true;
  bool _earnings = true;
  bool _promotions = false;
  bool _appUpdates = true;
  bool _sound = true;
  bool _vibration = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Notification Settings'),
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
            const SectionLabel('Alerts'),
            _toggle('New Job Alerts', 'Get notified for nearby job requests', Icons.work_rounded, _jobAlerts, (v) => setState(() => _jobAlerts = v)),
            const SizedBox(height: 12),
            _toggle('Earnings Updates', 'Receive payment and withdrawal alerts', Icons.account_balance_wallet_rounded, _earnings, (v) => setState(() => _earnings = v)),
            const SizedBox(height: 12),
            _toggle('Promotions', 'Deals, bonuses and incentive updates', Icons.local_offer_rounded, _promotions, (v) => setState(() => _promotions = v)),
            const SizedBox(height: 12),
            _toggle('App Updates', 'New features and improvements', Icons.system_update_rounded, _appUpdates, (v) => setState(() => _appUpdates = v)),
            const SizedBox(height: 24),
            const SectionLabel('Preferences'),
            _toggle('Sound', 'Play notification sound', Icons.volume_up_rounded, _sound, (v) => setState(() => _sound = v)),
            const SizedBox(height: 12),
            _toggle('Vibration', 'Vibrate on notifications', Icons.vibration_rounded, _vibration, (v) => setState(() => _vibration = v)),
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
                      'Critical alerts like job cancellations and security notifications cannot be turned off.',
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

  Widget _toggle(String title, String subtitle, IconData icon, bool value, ValueChanged<bool> onChanged) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: value ? AppColors.red.withValues(alpha: 0.12) : AppColors.border.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: value ? AppColors.red : AppColors.grey, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(color: AppColors.grey, fontSize: 11)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.red,
            activeTrackColor: AppColors.red.withValues(alpha: 0.3),
            inactiveThumbColor: AppColors.grey,
            inactiveTrackColor: AppColors.border,
          ),
        ],
      ),
    );
  }
}
