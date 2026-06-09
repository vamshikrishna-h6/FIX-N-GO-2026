import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class RateAppScreen extends StatefulWidget {
  const RateAppScreen({super.key});

  @override
  State<RateAppScreen> createState() => _RateAppScreenState();
}

class _RateAppScreenState extends State<RateAppScreen> {
  int _rating = 0;
  final TextEditingController _feedbackCtrl = TextEditingController();
  bool _submitted = false;

  @override
  void dispose() {
    _feedbackCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a rating')),
      );
      return;
    }
    setState(() => _submitted = true);
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
            child: const Icon(Icons.arrow_back_rounded,
                color: AppColors.textPrimary, size: 20),
          ),
        ),
        title: Text('Rate the App',
            style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textWhite)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: _submitted ? _buildThankYou() : _buildForm(),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      children: [
        const SizedBox(height: 30),
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.brandBlue, AppColors.accentCyan],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(Icons.build_rounded, color: Colors.white, size: 40),
        ),
        const SizedBox(height: 20),
        Text('How is your experience?',
            style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textWhite)),
        const SizedBox(height: 8),
        Text('Your feedback helps us improve Fix-N-Go',
            style: GoogleFonts.poppins(
                fontSize: 14, color: AppColors.textSecondary)),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (i) {
            final starIndex = i + 1;
            return GestureDetector(
              onTap: () => setState(() => _rating = starIndex),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Icon(
                  starIndex <= _rating
                      ? Icons.star_rounded
                      : Icons.star_outline_rounded,
                  size: 44,
                  color: starIndex <= _rating
                      ? AppColors.starYellow
                      : AppColors.textMuted,
                ),
              ),
            );
          }),
        ),
        if (_rating > 0) ...[
          const SizedBox(height: 8),
          Text(
            _rating <= 2
                ? 'We\'ll do better!'
                : _rating <= 4
                    ? 'Thank you!'
                    : 'Awesome!',
            style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.starYellow),
          ),
        ],
        const SizedBox(height: 24),
        TextField(
          controller: _feedbackCtrl,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'Tell us more (optional)...',
            hintStyle: GoogleFonts.poppins(color: AppColors.textMuted),
            filled: true,
            fillColor: AppColors.bgCard,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.borderColor),
            ),
          ),
          style: GoogleFonts.poppins(color: AppColors.textPrimary, fontSize: 14),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brandBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: Text('Submit Rating',
                style: GoogleFonts.poppins(
                    fontSize: 15, fontWeight: FontWeight.w700)),
          ),
        ),
      ],
    );
  }

  Widget _buildThankYou() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.brandGreen.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_rounded,
                color: AppColors.brandGreen, size: 50),
          ),
          const SizedBox(height: 24),
          Text('Thank you!',
              style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textWhite)),
          const SizedBox(height: 8),
          Text('Your feedback has been recorded.',
              style: GoogleFonts.poppins(
                  fontSize: 14, color: AppColors.textSecondary)),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brandBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                  horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: Text('Back to Profile',
                style: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
