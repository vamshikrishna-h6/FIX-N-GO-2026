import 'package:flutter/material.dart';
import '../api_service_new.dart';
import '../widgets/common_widgets.dart';

class ActivityHistoryScreen extends StatefulWidget {
  const ActivityHistoryScreen({super.key});

  @override
  State<ActivityHistoryScreen> createState() => _ActivityHistoryScreenState();
}

class _ActivityHistoryScreenState extends State<ActivityHistoryScreen> with SingleTickerProviderStateMixin {
  final _api = ApiService();
  late TabController _tabCtrl;
  List<dynamic> _allJobs = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
    _fetchHistory();
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  Future<void> _fetchHistory() async {
    setState(() => _loading = true);
    final jobs = await _api.getJobHistory();
    if (!mounted) return;
    setState(() {
      _allJobs = jobs;
      _loading = false;
    });
  }

  List<dynamic> _filterByStatus(String status) {
    if (status == 'all') return _allJobs;
    return _allJobs.where((j) => j['status'] == status).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Activity History'),
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
        bottom: TabBar(
          controller: _tabCtrl,
          indicatorColor: AppColors.red,
          labelColor: AppColors.red,
          unselectedLabelColor: AppColors.grey,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Completed'),
            Tab(text: 'Cancelled'),
          ],
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.red, strokeWidth: 2))
          : TabBarView(
              controller: _tabCtrl,
              children: [
                _buildList(_filterByStatus('all')),
                _buildList(_filterByStatus('completed')),
                _buildList(_filterByStatus('cancelled')),
              ],
            ),
    );
  }

  Widget _buildList(List<dynamic> jobs) {
    if (jobs.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history_rounded, color: AppColors.grey, size: 56),
            SizedBox(height: 12),
            Text('No activity found', style: TextStyle(color: AppColors.grey, fontSize: 14)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.red,
      backgroundColor: AppColors.card,
      onRefresh: _fetchHistory,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: jobs.length,
        itemBuilder: (context, index) {
          final job = jobs[index];
          final dateStr = job['completedAt'] ?? job['createdAt'] ?? '';
          String formattedDate = '';
          if (dateStr.isNotEmpty) {
            try {
              final date = DateTime.parse(dateStr);
              formattedDate = '${date.day}/${date.month}/${date.year}';
            } catch (_) {}
          }

          return GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/job_detail', arguments: job),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: _statusColor(job['status']).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(_statusIcon(job['status']), color: _statusColor(job['status']), size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job['serviceType'] ?? 'General Repair',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formattedDate,
                          style: const TextStyle(color: AppColors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹${job['estimatedPrice'] ?? 0}',
                        style: const TextStyle(color: AppColors.green, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 4),
                      StatusBadge(status: job['status'] ?? 'unknown'),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Color _statusColor(String? status) {
    switch (status) {
      case 'completed':
        return AppColors.green;
      case 'cancelled':
        return AppColors.red;
      case 'in_progress':
        return AppColors.orange;
      default:
        return AppColors.grey;
    }
  }

  IconData _statusIcon(String? status) {
    switch (status) {
      case 'completed':
        return Icons.check_circle_rounded;
      case 'cancelled':
        return Icons.cancel_rounded;
      case 'in_progress':
        return Icons.pending_rounded;
      default:
        return Icons.history_rounded;
    }
  }
}
