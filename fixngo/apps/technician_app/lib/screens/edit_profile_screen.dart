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
  final _experienceCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = true;
  bool _saving = false;
  List<String> _selectedSkills = [];

  final List<String> _allSkills = [
    'Screen Replacement',
    'Battery Fix',
    'Water Damage',
    'Charging Port',
    'Software Issues',
    'Camera Repair',
    'Speaker Repair',
    'Motherboard Repair',
    'Back Panel',
    'Button Repair',
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
    _experienceCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final dash = await _api.getDashboard();
    if (!mounted) return;
    setState(() {
      _nameCtrl.text = dash?['name'] ?? '';
      _phoneCtrl.text = dash?['phone'] ?? '';
      _experienceCtrl.text = dash?['experience'] ?? '';
      _selectedSkills = List<String>.from(dash?['specialization'] ?? []);
      _loading = false;
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final result = await _api.updateTechnicianProfile(
      specialization: _selectedSkills,
      experience: _experienceCtrl.text.trim(),
    );
    if (!mounted) return;
    setState(() => _saving = false);
    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully'), backgroundColor: AppColors.green),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update profile'), backgroundColor: AppColors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Edit Profile'),
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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionLabel('Name'),
                    TextFormField(
                      controller: _nameCtrl,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Your full name',
                        prefixIcon: Icon(Icons.person_outline_rounded),
                      ),
                      validator: (v) => v == null || v.trim().isEmpty ? 'Name is required' : null,
                    ),
                    const SizedBox(height: 16),
                    const SectionLabel('Phone'),
                    TextFormField(
                      controller: _phoneCtrl,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        hintText: '+91 XXXXX XXXXX',
                        prefixIcon: Icon(Icons.phone_outlined),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const SectionLabel('Experience'),
                    TextFormField(
                      controller: _experienceCtrl,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'e.g. 4 years',
                        prefixIcon: Icon(Icons.work_outline_rounded),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const SectionLabel('Specializations'),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _allSkills.map((skill) {
                        final selected = _selectedSkills.contains(skill);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (selected) {
                                _selectedSkills.remove(skill);
                              } else {
                                _selectedSkills.add(skill);
                              }
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: selected ? AppColors.red.withValues(alpha: 0.15) : AppColors.card,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: selected ? AppColors.red : AppColors.border,
                              ),
                            ),
                            child: Text(
                              skill,
                              style: TextStyle(
                                color: selected ? AppColors.red : AppColors.grey,
                                fontSize: 13,
                                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 32),
                    PrimaryButton(
                      label: 'Save Changes',
                      isLoading: _saving,
                      color: AppColors.green,
                      icon: Icons.check_rounded,
                      onTap: _save,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
