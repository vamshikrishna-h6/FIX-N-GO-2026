import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class MyRatingsScreen extends StatefulWidget {
  const MyRatingsScreen({super.key});

  @override
  State<MyRatingsScreen> createState() => _MyRatingsScreenState();
}

class _MyRatingsScreenState extends State<MyRatingsScreen> {
  final ApiService _apiService = ApiService();
  final StorageService _storage = StorageService();
  List<dynamic> _ratings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRatings();
  }

  Future<void> _fetchRatings() async {
    try {
      final token = await _storage.getToken();
      _apiService.setToken(token);
      final res = await _apiService.get('/api/ratings/my-ratings');
      if (!mounted) return;
      setState(() {
        _ratings = (res['data'] as List<dynamic>?) ?? [];
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
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
        title: Text('My Reviews', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.brandBlue))
          : _ratings.isEmpty
              ? _buildEmpty()
              : RefreshIndicator(
                  onRefresh: _fetchRatings,
                  color: AppColors.brandBlue,
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                    padding: const EdgeInsets.all(20),
                    itemCount: _ratings.length,
                    itemBuilder: (context, i) => _buildRatingCard(_ratings[i]),
                  ),
                ),
    );
  }

  Widget _buildRatingCard(Map<String, dynamic> rating) {
    final stars = (rating['rating'] as num?)?.toInt() ?? 0;
    final review = rating['review'] as String? ?? '';
    final createdAt = rating['createdAt'] as String? ?? '';
    final date = createdAt.length >= 10 ? createdAt.substring(0, 10) : createdAt;
    final tech = rating['technician'] as Map<String, dynamic>?;
    final techName = tech?['name'] as String? ?? 'Technician';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.brandBlue.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.person_rounded, color: AppColors.brandBlue, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(techName, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                    Text(date, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textMuted)),
                  ],
                ),
              ),
              Row(
                children: List.generate(5, (i) => Icon(
                  i < stars ? Icons.star_rounded : Icons.star_border_rounded,
                  size: 18,
                  color: i < stars ? AppColors.starYellow : AppColors.textMuted,
                )),
              ),
            ],
          ),
          if (review.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(review, style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary)),
          ],
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.borderColor),
            ),
            child: const Icon(Icons.star_border_rounded, size: 36, color: AppColors.textMuted),
          ),
          const SizedBox(height: 16),
          Text("You haven't rated anyone yet", style: GoogleFonts.poppins(fontSize: 15, color: AppColors.textMuted)),
        ],
      ),
    );
  }
}
