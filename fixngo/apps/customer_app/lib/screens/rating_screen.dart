import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class RatingScreen extends StatefulWidget {
  final String orderId;
  final String technicianId;
  const RatingScreen({super.key, required this.orderId, required this.technicianId});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  final ApiService _apiService = ApiService();
  final StorageService _storage = StorageService();
  final TextEditingController _reviewController = TextEditingController();
  int _rating = 0;
  bool _submitting = false;

  Future<void> _submit() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a rating')),
      );
      return;
    }
    setState(() => _submitting = true);
    try {
      final token = await _storage.getToken();
      _apiService.setToken(token);
      await _apiService.post('/api/ratings/create', {
        'orderId': widget.orderId,
        'technicianId': widget.technicianId,
        'rating': _rating,
        'review': _reviewController.text.trim(),
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Rating submitted!')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit: $e')),
        );
      }
    }
    if (mounted) setState(() => _submitting = false);
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(
        backgroundColor: AppColors.bgDark,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.borderColor),
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: AppColors.textPrimary),
          ),
        ),
        title: Text('Rate Technician', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppColors.brandBlue, AppColors.accentCyan]),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person_rounded, color: Colors.white, size: 44),
            ),
            const SizedBox(height: 16),
            Text(
              'How was your experience?',
              style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textWhite),
            ),
            const SizedBox(height: 8),
            Text(
              'Your feedback helps us improve',
              style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 32),

            // Stars
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) {
                final starIndex = i + 1;
                return GestureDetector(
                  onTap: () => setState(() => _rating = starIndex),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: AnimatedScale(
                      scale: _rating >= starIndex ? 1.2 : 1.0,
                      duration: const Duration(milliseconds: 150),
                      child: Icon(
                        _rating >= starIndex ? Icons.star_rounded : Icons.star_border_rounded,
                        size: 48,
                        color: _rating >= starIndex ? AppColors.starYellow : AppColors.textMuted,
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 8),
            Text(
              _rating == 0
                  ? 'Tap to rate'
                  : _rating <= 2
                      ? 'Poor'
                      : _rating == 3
                          ? 'Average'
                          : _rating == 4
                              ? 'Good'
                              : 'Excellent!',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: _rating == 0 ? AppColors.textMuted : AppColors.starYellow,
              ),
            ),

            const SizedBox(height: 32),

            // Review text
            Container(
              decoration: BoxDecoration(
                color: AppColors.bgCard,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.borderColor),
              ),
              child: TextField(
                controller: _reviewController,
                maxLines: 4,
                style: GoogleFonts.poppins(color: AppColors.textPrimary, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Write a review (optional)',
                  hintStyle: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 14),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Submit button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brandBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  disabledBackgroundColor: AppColors.brandBlue.withValues(alpha: 0.5),
                ),
                child: _submitting
                    ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : Text('Submit Rating', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
