import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/common_widgets.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _jobAlerts = true;
  bool _paymentAlerts = true;
  bool _promotions = false;
  bool _statusUpdates = true;
  bool _chatMessages = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _jobAlerts = prefs.getBool('notif_job_alerts') ?? true;
      _paymentAlerts = prefs.getBool('notif_payment_alerts') ?? true;
      _promotions = prefs.getBool('notif_promotions') ?? false;
      _statusUpdates = prefs.getBool('notif_status_updates') ?? true;
      _chatMessages = prefs.getBool('notif_chat_messages') ?? true;
      _soundEnabled = prefs.getBool('notif_sound') ?? true;
      _vibrationEnabled = prefs.getBool('notif_vibration') ?? true;
      _loading = false;
    });
  }

  Future<void> _saveSetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Widget _settingTile(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(color: AppColors.grey, fontSize: 12)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.green,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Notification Settings'),
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
                  const SectionLabel('Notification Types'),
                  _settingTile('Job Alerts', 'New job requests and assignments', _jobAlerts, (v) {
                    setState(() => _jobAlerts = v);
                    _saveSetting('notif_job_alerts', v);
                  }),
                  _settingTile('Payment Alerts', 'Earnings and withdrawal updates', _paymentAlerts, (v) {
                    setState(() => _paymentAlerts = v);
                    _saveSetting('notif_payment_alerts', v);
                  }),
                  _settingTile('Status Updates', 'Job status changes', _statusUpdates, (v) {
                    setState(() => _statusUpdates = v);
                    _saveSetting('notif_status_updates', v);
                  }),
                  _settingTile('Chat Messages', 'Customer and support messages', _chatMessages, (v) {
                    setState(() => _chatMessages = v);
                    _saveSetting('notif_chat_messages', v);
                  }),
                  _settingTile('Promotions', 'Offers and incentives', _promotions, (v) {
                    setState(() => _promotions = v);
                    _saveSetting('notif_promotions', v);
                  }),
                  const SizedBox(height: 12),
                  const SectionLabel('Preferences'),
                  _settingTile('Sound', 'Play sound for notifications', _soundEnabled, (v) {
                    setState(() => _soundEnabled = v);
                    _saveSetting('notif_sound', v);
                  }),
                  _settingTile('Vibration', 'Vibrate on notifications', _vibrationEnabled, (v) {
                    setState(() => _vibrationEnabled = v);
                    _saveSetting('notif_vibration', v);
                  }),
                ],
              ),
            ),
    );
  }
}
