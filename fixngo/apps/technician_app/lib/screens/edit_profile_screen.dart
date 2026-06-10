import 'package:flutter/material.dart';

import '../api_service_new.dart';
import '../widgets/common_widgets.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _api = ApiService();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _expCtrl = TextEditingController();
  bool _loading = true;
  bool _saving = false;
  List<String> _selectedSkills = [];

  static const List<String> _allSkills = [
    'Screen Replacement',
    'Battery Fix',
    'Water Damage',
    'Charging Port',
    'Software Issues',
    'Speaker Repair',
    'Camera Repair',
    'Back Panel',
  ];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _expCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final dash = await _api.getDashboard();
    if (!mounted) return;
    setState(() {
      _nameCtrl.text = dash?['name'] ?? '';
      _phoneCtrl.text = dash?['phone'] ?? '';
      _emailCtrl.text = dash?['email'] ?? '';
      _expCtrl.text = dash?['experience'] ?? '';
      final skills = dash?['specialization'];
      if (skills is List) {
        _selectedSkills = skills.map((e) => e.toString()).toList();
      }
      _loading = false;
    });
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    await _api.updateTechnicianProfile(
      specialization: _selectedSkills,
      experience: _expCtrl.text.trim(),
    );
    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated'), backgroundColor: AppColors.green),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Edit Profile'),
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
                  const SectionLabel('Personal Details'),
                  _field('Full Name', _nameCtrl, Icons.person_rounded, enabled: false),
                  const SizedBox(height: 14),
                  _field('Email', _emailCtrl, Icons.mail_outline_rounded, enabled: false),
                  const SizedBox(height: 14),
                  _field('Phone', _phoneCtrl, Icons.phone_rounded, enabled: false),
                  const SizedBox(height: 14),
                  _field('Experience', _expCtrl, Icons.work_history_rounded),
                  const SizedBox(height: 24),
                  const SectionLabel('Specializations'),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _allSkills.map((s) {
                      final selected = _selectedSkills.contains(s);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (selected) {
                              _selectedSkills.remove(s);
                            } else {
                              _selectedSkills.add(s);
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: selected ? AppColors.red.withValues(alpha: 0.15) : AppColors.card,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: selected ? AppColors.red : AppColors.border,
                            ),
                          ),
                          child: Text(
                            s,
                            style: TextStyle(
                              color: selected ? AppColors.red : AppColors.grey,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),
                  PrimaryButton(
                    label: 'Save Changes',
                    onTap: _save,
                    isLoading: _saving,
                    icon: Icons.check_rounded,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  Widget _field(String label, TextEditingController ctrl, IconData icon, {bool enabled = true}) {
    return TextField(
      controller: ctrl,
      enabled: enabled,
      style: TextStyle(color: enabled ? Colors.white : AppColors.grey),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.grey, fontSize: 13),
        prefixIcon: Icon(icon, color: AppColors.grey, size: 20),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border),
        ),
      ),
    );
  }
}
