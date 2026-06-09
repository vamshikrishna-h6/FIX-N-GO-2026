import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_service_new.dart';
import 'theme/app_theme.dart';
import 'widgets/common_widgets.dart';

class RatingsScreen extends StatefulWidget {
  const RatingsScreen({super.key});

  @override
  State<RatingsScreen> createState() => _RatingsScreenState();
}

class _RatingsScreenState extends State<RatingsScreen> {
  final _api = ApiService();
  List<dynamic> _ratings = [];
  bool _loading = true;
  double _averageRating = 0;
  int _totalRatings = 0;

  @override
  void initState() {
    super.initState();
    _fetchRatings();
  }

  Future<void> _fetchRatings() async {
    final prefs = await SharedPreferences.getInstance();
    final techId = prefs.getString('userId') ?? prefs.getString('technicianId') ?? '';
    if (techId.isEmpty) {
      // Try getting from dashboard
      final dash = await _api.getDashboard();
      final id = dash?['_id'] as String? ?? dash?['userId'] as String? ?? '';
      if (id.isNotEmpty) {
        await prefs.setString('userId', id);
        await _loadRatings(id);
      } else {
        if (mounted) setState(() => _loading = false);
      }
      return;
    }
    await _loadRatings(techId);
  }

  Future<void> _loadRatings(String techId) async {
    final ratings = await _api.getMyRatings(techId);
    final avg = await _api.getAverageRating(techId);
    if (!mounted) return;
    setState(() {
      _ratings = ratings;
      _averageRating = (avg?['averageRating'] as num?)?.toDouble() ?? 0;
      _totalRatings = (avg?['totalRatings'] as num?)?.toInt() ?? ratings.length;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        title: const Text('My Reviews'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.green))
          : RefreshIndicator(
              onRefresh: _fetchRatings,
              color: AppColors.green,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                padding: const EdgeInsets.all(20),
                children: [
                  _buildSummaryCard(),
                  const SizedBox(height: 24),
                  const SectionLabel('CUSTOMER REVIEWS'),
                  if (_ratings.isEmpty)
                    _buildEmpty()
                  else
                    ..._ratings.map((r) => _buildRatingCard(r as Map<String, dynamic>)),
                ],
              ),
            ),
    );
  }

  Widget _buildSummaryCard() {
    return GlassCard(
      child: Row(
        children: [
          Column(
            children: [
              Text(
                _averageRating.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w800,
                  color: AppColors.yellow,
                ),
              ),
              Row(
                children: List.generate(5, (i) {
                  final filled = i < _averageRating.round();
                  return Icon(
                    filled ? Icons.star_rounded : Icons.star_border_rounded,
                    size: 20,
                    color: filled ? AppColors.yellow : AppColors.grey,
                  );
                }),
              ),
              const SizedBox(height: 4),
              Text(
                '$_totalRatings reviews',
                style: const TextStyle(color: AppColors.grey, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(width: 28),
          Expanded(
            child: Column(
              children: List.generate(5, (i) {
                final star = 5 - i;
                final count = _ratings.where((r) {
                  final rating = (r as Map<String, dynamic>)['rating'] as num? ?? 0;
                  return rating.toInt() == star;
                }).length;
                final percent = _totalRatings > 0 ? count / _totalRatings : 0.0;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Text('$star', style: const TextStyle(color: AppColors.grey, fontSize: 12)),
                      const SizedBox(width: 6),
                      const Icon(Icons.star_rounded, size: 12, color: AppColors.yellow),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: percent,
                            backgroundColor: AppColors.card,
                            valueColor: const AlwaysStoppedAnimation(AppColors.yellow),
                            minHeight: 6,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 24,
                        child: Text(
                          '$count',
                          style: const TextStyle(color: AppColors.grey, fontSize: 11),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingCard(Map<String, dynamic> rating) {
    final stars = (rating['rating'] as num?)?.toInt() ?? 0;
    final review = rating['review'] as String? ?? '';
    final createdAt = rating['createdAt'] as String? ?? '';
    final date = createdAt.length >= 10 ? createdAt.substring(0, 10) : createdAt;
    final customer = rating['customer'] as Map<String, dynamic>?;
    final customerName = customer?['name'] as String? ?? 'Customer';

    return Container(
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
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.green.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.person_rounded, color: AppColors.green, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(customerName,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.white)),
                    Text(date, style: const TextStyle(fontSize: 11, color: AppColors.grey)),
                  ],
                ),
              ),
              Row(
                children: List.generate(5, (i) => Icon(
                  i < stars ? Icons.star_rounded : Icons.star_border_rounded,
                  size: 16,
                  color: i < stars ? AppColors.yellow : AppColors.grey,
                )),
              ),
            ],
          ),
          if (review.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(review, style: const TextStyle(fontSize: 13, color: AppColors.greyLight, height: 1.4)),
          ],
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.star_border_rounded, size: 48, color: AppColors.grey.withValues(alpha: 0.5)),
            const SizedBox(height: 12),
            const Text('No reviews yet', style: TextStyle(color: AppColors.grey, fontSize: 15)),
            const SizedBox(height: 4),
            const Text('Complete jobs to get customer reviews', style: TextStyle(color: AppColors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
