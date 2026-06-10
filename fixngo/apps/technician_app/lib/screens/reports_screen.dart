import 'package:flutter/material.dart';
import '../api_service_new.dart';
import '../widgets/common_widgets.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final _api = ApiService();
  Map<String, dynamic>? _stats;
  List<dynamic> _recentJobs = [];
  bool _loading = true;
  String _period = 'week';

  @override
  void initState() {
    super.initState();
    _fetchReports();
  }

  Future<void> _fetchReports() async {
    setState(() => _loading = true);
    final dash = await _api.getDashboard();
    final jobs = await _api.getJobHistory();
    if (!mounted) return;
    setState(() {
      _stats = dash;
      _recentJobs = jobs;
      _loading = false;
    });
  }

  int get _completedJobs => _recentJobs.where((j) => j['status'] == 'completed').length;
  int get _cancelledJobs => _recentJobs.where((j) => j['status'] == 'cancelled').length;
  int get _totalEarnings {
    int total = 0;
    for (final job in _recentJobs.where((j) => j['status'] == 'completed')) {
      total += (job['estimatedPrice'] as num?)?.toInt() ?? 0;
    }
    return total;
  }

  double get _completionRate {
    if (_recentJobs.isEmpty) return 0;
    return (_completedJobs / _recentJobs.length) * 100;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Reports & Analytics'),
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
          : RefreshIndicator(
              color: AppColors.red,
              backgroundColor: AppColors.card,
              onRefresh: _fetchReports,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPeriodSelector(),
                    const SizedBox(height: 20),
                    _buildOverviewCards(),
                    const SizedBox(height: 24),
                    _buildPerformanceSection(),
                    const SizedBox(height: 24),
                    _buildEarningsBreakdown(),
                    const SizedBox(height: 24),
                    _buildServiceTypeBreakdown(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildPeriodSelector() {
    return Row(
      children: ['week', 'month', 'year'].map((p) {
        final selected = _period == p;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _period = p),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: selected ? AppColors.red : AppColors.card,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: selected ? AppColors.red : AppColors.border),
              ),
              child: Center(
                child: Text(
                  p[0].toUpperCase() + p.substring(1),
                  style: TextStyle(
                    color: selected ? Colors.white : AppColors.grey,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildOverviewCards() {
    return Row(
      children: [
        _metricCard('₹$_totalEarnings', 'Total Earnings', AppColors.green, Icons.currency_rupee_rounded),
        const SizedBox(width: 12),
        _metricCard('$_completedJobs', 'Completed', AppColors.green, Icons.check_circle_rounded),
      ],
    );
  }

  Widget _metricCard(String value, String label, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 12),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(color: AppColors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Performance', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          _performanceRow('Completion Rate', '${_completionRate.toStringAsFixed(1)}%', AppColors.green),
          const SizedBox(height: 12),
          _performanceRow('Rating', '${_stats?['rating'] ?? '4.8'} / 5.0', AppColors.yellow),
          const SizedBox(height: 12),
          _performanceRow('Cancellations', '$_cancelledJobs', AppColors.red),
          const SizedBox(height: 12),
          _performanceRow('Avg Response Time', '< 2 min', AppColors.orange),
        ],
      ),
    );
  }

  Widget _performanceRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.grey, fontSize: 14)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(value, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 13)),
        ),
      ],
    );
  }

  Widget _buildEarningsBreakdown() {
    final wallet = _stats?['walletBalance'] ?? 0;
    final pending = _stats?['pendingEarnings'] ?? 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Earnings Breakdown', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          _earningsRow('Available Balance', '₹$wallet', AppColors.green),
          const SizedBox(height: 10),
          _earningsRow('Pending Clearance', '₹$pending', AppColors.yellow),
          const SizedBox(height: 10),
          _earningsRow('Platform Fee (15%)', '₹${(_totalEarnings * 0.15).toInt()}', AppColors.red),
        ],
      ),
    );
  }

  Widget _earningsRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(color: AppColors.greyLight, fontSize: 14)),
          ],
        ),
        Text(value, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildServiceTypeBreakdown() {
    final Map<String, int> typeCounts = {};
    for (final job in _recentJobs) {
      final type = job['serviceType'] as String? ?? 'Other';
      typeCounts[type] = (typeCounts[type] ?? 0) + 1;
    }
    final sorted = typeCounts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Service Types', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          ...sorted.take(5).map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(entry.key, style: const TextStyle(color: AppColors.greyLight, fontSize: 14)),
                    ),
                    Text('${entry.value} jobs', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
                  ],
                ),
              )),
          if (sorted.isEmpty)
            const Text('No data yet', style: TextStyle(color: AppColors.grey, fontSize: 13)),
        ],
      ),
    );
  }
}
