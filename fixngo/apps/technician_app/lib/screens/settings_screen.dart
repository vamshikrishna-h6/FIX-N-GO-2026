import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/common_widgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = true;
  bool _autoAccept = false;
  bool _locationSharing = true;
  double _maxDistance = 10.0;
  String _language = 'English';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkMode = prefs.getBool('setting_dark_mode') ?? true;
      _autoAccept = prefs.getBool('setting_auto_accept') ?? false;
      _locationSharing = prefs.getBool('setting_location_sharing') ?? true;
      _maxDistance = prefs.getDouble('setting_max_distance') ?? 10.0;
      _language = prefs.getString('setting_language') ?? 'English';
      _loading = false;
    });
  }

  Future<void> _saveBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<void> _saveDouble(String key, double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(key, value);
  }

  Widget _settingSwitch(String title, String subtitle, IconData icon, bool value, ValueChanged<bool> onChanged) {
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
          Icon(icon, color: AppColors.grey, size: 22),
          const SizedBox(width: 14),
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
          Switch(value: value, onChanged: onChanged, activeTrackColor: AppColors.green),
        ],
      ),
    );
  }

  Widget _settingTap(String title, String subtitle, IconData icon, String trailing, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.grey, size: 22),
            const SizedBox(width: 14),
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
            Text(trailing, style: const TextStyle(color: AppColors.grey, fontSize: 13)),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.grey, size: 14),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Settings'),
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
                  const SectionLabel('Appearance'),
                  _settingSwitch('Dark Mode', 'Use dark theme throughout', Icons.dark_mode_rounded, _darkMode, (v) {
                    setState(() => _darkMode = v);
                    _saveBool('setting_dark_mode', v);
                  }),
                  _settingTap('Language', 'App display language', Icons.language_rounded, _language, _showLanguageDialog),
                  const SizedBox(height: 8),
                  const SectionLabel('Job Preferences'),
                  _settingSwitch('Auto-Accept Jobs', 'Automatically accept nearby jobs', Icons.flash_on_rounded, _autoAccept, (v) {
                    setState(() => _autoAccept = v);
                    _saveBool('setting_auto_accept', v);
                  }),
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.radar_rounded, color: AppColors.grey, size: 22),
                            const SizedBox(width: 14),
                            const Expanded(
                              child: Text('Max Job Distance', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                            ),
                            Text('${_maxDistance.toInt()} km', style: const TextStyle(color: AppColors.green, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        Slider(
                          value: _maxDistance,
                          min: 1,
                          max: 50,
                          divisions: 49,
                          activeColor: AppColors.green,
                          inactiveColor: AppColors.border,
                          onChanged: (v) {
                            setState(() => _maxDistance = v);
                            _saveDouble('setting_max_distance', v);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const SectionLabel('Privacy'),
                  _settingSwitch('Location Sharing', 'Share location while online', Icons.location_on_rounded, _locationSharing, (v) {
                    setState(() => _locationSharing = v);
                    _saveBool('setting_location_sharing', v);
                  }),
                  const SizedBox(height: 8),
                  const SectionLabel('Data'),
                  _settingTap('Clear Cache', 'Free up storage space', Icons.cleaning_services_rounded, '', _clearCache),
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      'Fix-N-Go Technician v1.0.0',
                      style: TextStyle(color: AppColors.grey.withValues(alpha: 0.6), fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text('Select Language', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['English', 'Hindi', 'Telugu', 'Tamil', 'Kannada'].map((lang) {
            return ListTile(
              title: Text(lang, style: const TextStyle(color: Colors.white)),
              trailing: _language == lang ? const Icon(Icons.check, color: AppColors.green) : null,
              onTap: () async {
                final nav = Navigator.of(context);
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('setting_language', lang);
                if (!mounted) return;
                setState(() => _language = lang);
                nav.pop();
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cached_jobs');
    await prefs.remove('cached_dashboard');
    await prefs.remove('cached_notifications');
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cache cleared'), backgroundColor: AppColors.green),
    );
  }
}
