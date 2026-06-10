import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../api_service_new.dart';
import '../widgets/common_widgets.dart';

class DocumentsKycScreen extends StatefulWidget {
  const DocumentsKycScreen({super.key});

  @override
  State<DocumentsKycScreen> createState() => _DocumentsKycScreenState();
}

class _DocumentsKycScreenState extends State<DocumentsKycScreen> {
  final _api = ApiService();
  final _picker = ImagePicker();
  final _aadhaarCtrl = TextEditingController();
  String? _frontPath;
  String? _backPath;
  bool _uploading = false;
  bool _loading = true;
  Map<String, dynamic>? _kycData;

  @override
  void initState() {
    super.initState();
    _loadKycStatus();
  }

  @override
  void dispose() {
    _aadhaarCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadKycStatus() async {
    final dash = await _api.getDashboard();
    if (!mounted) return;
    setState(() {
      _kycData = dash;
      _loading = false;
    });
  }

  Future<void> _pickImage(bool isFront) async {
    final image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (image == null) return;
    setState(() {
      if (isFront) {
        _frontPath = image.path;
      } else {
        _backPath = image.path;
      }
    });
  }

  Future<void> _uploadKyc() async {
    if (_aadhaarCtrl.text.trim().length != 12) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid 12-digit Aadhaar number'), backgroundColor: AppColors.red),
      );
      return;
    }
    if (_frontPath == null || _backPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both front and back images'), backgroundColor: AppColors.red),
      );
      return;
    }

    setState(() => _uploading = true);
    final result = await _api.uploadTechnicianKyc(
      aadhaarNumber: _aadhaarCtrl.text.trim(),
      frontPath: _frontPath!,
      backPath: _backPath!,
    );
    if (!mounted) return;
    setState(() => _uploading = false);

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('KYC documents uploaded successfully'), backgroundColor: AppColors.green),
      );
      _loadKycStatus();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to upload KYC documents'), backgroundColor: AppColors.red),
      );
    }
  }

  Widget _docCard(String title, String? path, bool isFront) {
    return GestureDetector(
      onTap: () => _pickImage(isFront),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: path != null ? AppColors.green : AppColors.border),
        ),
        child: Column(
          children: [
            Icon(
              path != null ? Icons.check_circle_rounded : Icons.upload_file_rounded,
              color: path != null ? AppColors.green : AppColors.grey,
              size: 40,
            ),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(
              path != null ? 'Image selected' : 'Tap to upload',
              style: TextStyle(color: path != null ? AppColors.green : AppColors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isVerified = _kycData?['kycVerified'] == true;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Documents & KYC'),
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
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isVerified
                          ? AppColors.green.withValues(alpha: 0.1)
                          : AppColors.yellow.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isVerified
                            ? AppColors.green.withValues(alpha: 0.3)
                            : AppColors.yellow.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isVerified ? Icons.verified_rounded : Icons.pending_rounded,
                          color: isVerified ? AppColors.green : AppColors.yellow,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isVerified ? 'KYC Verified' : 'KYC Pending',
                                style: TextStyle(
                                  color: isVerified ? AppColors.green : AppColors.yellow,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                isVerified
                                    ? 'Your documents have been verified'
                                    : 'Upload your Aadhaar to get verified',
                                style: const TextStyle(color: AppColors.grey, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const SectionLabel('Aadhaar Number'),
                  TextField(
                    controller: _aadhaarCtrl,
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    maxLength: 12,
                    decoration: const InputDecoration(
                      hintText: '12-digit Aadhaar number',
                      prefixIcon: Icon(Icons.credit_card_rounded),
                      counterText: '',
                    ),
                  ),
                  const SizedBox(height: 20),
                  const SectionLabel('Aadhaar Front'),
                  _docCard('Aadhaar Front Side', _frontPath, true),
                  const SizedBox(height: 12),
                  const SectionLabel('Aadhaar Back'),
                  _docCard('Aadhaar Back Side', _backPath, false),
                  const SizedBox(height: 32),
                  PrimaryButton(
                    label: 'Upload Documents',
                    isLoading: _uploading,
                    color: AppColors.green,
                    icon: Icons.cloud_upload_rounded,
                    onTap: _uploadKyc,
                  ),
                ],
              ),
            ),
    );
  }
}
