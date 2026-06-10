import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../widgets/common_widgets.dart';

class JobPhotosScreen extends StatefulWidget {
  final String jobId;
  const JobPhotosScreen({super.key, required this.jobId});

  @override
  State<JobPhotosScreen> createState() => _JobPhotosScreenState();
}

class _JobPhotosScreenState extends State<JobPhotosScreen> {
  final _picker = ImagePicker();
  List<Map<String, dynamic>> _photos = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadPhotos();
  }

  Future<void> _loadPhotos() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('job_photos_${widget.jobId}');
    if (data != null) {
      _photos = (jsonDecode(data) as List<dynamic>).cast<Map<String, dynamic>>();
    }
    setState(() => _loading = false);
  }

  Future<void> _savePhotos() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('job_photos_${widget.jobId}', jsonEncode(_photos));
  }

  Future<void> _takePhoto() async {
    final image = await _picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    if (image == null) return;

    final photo = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'path': image.path,
      'timestamp': DateTime.now().toIso8601String(),
      'label': 'Photo ${_photos.length + 1}',
    };

    setState(() => _photos.add(photo));
    _savePhotos();
  }

  Future<void> _pickFromGallery() async {
    final image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (image == null) return;

    final photo = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'path': image.path,
      'timestamp': DateTime.now().toIso8601String(),
      'label': 'Photo ${_photos.length + 1}',
    };

    setState(() => _photos.add(photo));
    _savePhotos();
  }

  Future<void> _deletePhoto(String id) async {
    setState(() => _photos.removeWhere((p) => p['id'] == id));
    _savePhotos();
  }

  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_rounded, color: AppColors.red),
              title: const Text('Take Photo', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _takePhoto();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_rounded, color: AppColors.green),
              title: const Text('Choose from Gallery', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _pickFromGallery();
              },
            ),
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
        title: const Text('Photos & Documents'),
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
        actions: [
          IconButton(
            icon: const Icon(Icons.add_a_photo_rounded, color: Colors.white),
            onPressed: _showPhotoOptions,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.red, strokeWidth: 2))
          : _photos.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.photo_camera_outlined, color: AppColors.grey, size: 56),
                      const SizedBox(height: 12),
                      const Text('No photos yet', style: TextStyle(color: AppColors.grey, fontSize: 16)),
                      const SizedBox(height: 4),
                      const Text('Document the repair with photos', style: TextStyle(color: AppColors.grey, fontSize: 12)),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: _showPhotoOptions,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text('Add Photo', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: _photos.length,
                  itemBuilder: (context, index) {
                    final photo = _photos[index];
                    final timestamp = DateTime.tryParse(photo['timestamp'] ?? '');
                    final timeStr = timestamp != null
                        ? '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}'
                        : '';

                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(13)),
                              child: Image.file(
                                File(photo['path']),
                                fit: BoxFit.cover,
                                width: double.infinity,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  color: AppColors.surface,
                                  child: const Icon(Icons.broken_image_rounded, color: AppColors.grey, size: 32),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    timeStr,
                                    style: const TextStyle(color: AppColors.grey, fontSize: 11),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => _deletePhoto(photo['id']),
                                  child: const Icon(Icons.delete_outline_rounded, color: AppColors.red, size: 18),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
      floatingActionButton: _photos.isNotEmpty
          ? FloatingActionButton(
              backgroundColor: AppColors.red,
              onPressed: _showPhotoOptions,
              child: const Icon(Icons.add_a_photo_rounded, color: Colors.white),
            )
          : null,
    );
  }
}
