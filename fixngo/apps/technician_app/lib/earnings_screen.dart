import 'package:flutter/material.dart';

import 'api_service_new.dart';
import 'widgets/common_widgets.dart';

class EarningsScreen extends StatefulWidget {
  const EarningsScreen({super.key});

  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {
  final _apiService = ApiService();
  Map<String, dynamic>? _stats;
  bool _loading = true;

  final List<double> _weeklyData = [850, 1200, 650, 1800, 950, 2100, 1400];
  final List<String> _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  int _selectedDay = 6;

  @override
  void initState() {
    super.initState();
    _fetchStats();
  }

  Future<void> _fetchStats() async {
    final stats = await _apiService.getStats();
    if (!mounted) return;
    setState(() {
      _stats = stats;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
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
        title: const Text('Earnings'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/withdrawal'),
            child: const Text('Withdraw', style: TextStyle(color: AppColors.green, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.red, strokeWidth: 2))
          : RefreshIndicator(
              color: AppColors.red,
              backgroundColor: AppColors.card,
              onRefresh: _fetchStats,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildWalletCard(),
                    const SizedBox(height: 20),
                    _buildWeeklyChart(),
                    const SizedBox(height: 20),
                    _buildStatsGrid(),
                    const SizedBox(height: 20),
                    _buildTransactions(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildWalletCard() {
    final balance = _stats?['walletBalance'] ?? 0;
    final total = _stats?['totalEarnings'] ?? 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A2A1A), Color(0xFF0F1F0F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.green.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.green.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'WALLET BALANCE',
                  style: TextStyle(
                    color: AppColors.green,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const Spacer(),
              const Icon(Icons.account_balance_wallet_rounded, color: AppColors.green, size: 24),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '₹$balance',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 44,
              fontWeight: FontWeight.w900,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 4),
          Text('Total earned: ₹$total', style: const TextStyle(color: AppColors.grey, fontSize: 14)),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/withdrawal'),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.green,
                borderRadius: BorderRadius.circular(12),
                boxShadow: AppShadows.green,
              ),
              child: const Center(
                child: Text(
                  'Withdraw to Bank',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyChart() {
    final maxVal = _weeklyData.reduce((a, b) => a > b ? a : b);
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('This Week', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
              const Spacer(),
              Text('₹${_weeklyData.reduce((a, b) => a + b).toInt()}', style: const TextStyle(color: AppColors.green, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(_weeklyData.length, (i) {
                final h = (_weeklyData[i] / maxVal) * 100;
                final active = i == _selectedDay;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedDay = i),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (active)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text('₹${_weeklyData[i].toInt()}', style: const TextStyle(color: AppColors.green, fontSize: 9, fontWeight: FontWeight.w700)),
                            ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            height: h,
                            decoration: BoxDecoration(
                              color: active ? AppColors.green : AppColors.green.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _days[i],
                            style: TextStyle(
                              color: active ? Colors.white : AppColors.grey,
                              fontSize: 10,
                              fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    final jobs = _stats?['completedOrdersCount'] ?? 0;
    return Row(
      children: [
        Expanded(child: _statCard('$jobs', 'Jobs Done', Icons.check_circle_rounded, AppColors.orange)),
        const SizedBox(width: 10),
        Expanded(child: _statCard('4.8 ★', 'Avg Rating', Icons.star_rounded, AppColors.yellow)),
        const SizedBox(width: 10),
        Expanded(child: _statCard('97%', 'Accept Rate', Icons.thumb_up_rounded, AppColors.green)),
      ],
    );
  }

  Widget _statCard(String value, String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(color: AppColors.grey, fontSize: 10), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildTransactions() {
    final txns = [
      {'type': 'credit', 'desc': 'Screen Replacement', 'amt': 799, 'date': 'Today'},
      {'type': 'credit', 'desc': 'Battery Replacement', 'amt': 499, 'date': 'Today'},
      {'type': 'debit', 'desc': 'Withdrawal', 'amt': 1500, 'date': 'Yesterday'},
      {'type': 'credit', 'desc': 'Charging Port Fix', 'amt': 299, 'date': 'Yesterday'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel('Recent Transactions'),
        ...txns.map((t) {
          final credit = t['type'] == 'credit';
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: credit ? AppColors.green.withValues(alpha: 0.1) : AppColors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(credit ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded, color: credit ? AppColors.green : AppColors.red, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t['desc'] as String, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                      Text(t['date'] as String, style: const TextStyle(color: AppColors.grey, fontSize: 12)),
                    ],
                  ),
                ),
                Text(
                  '${credit ? '+' : '-'}₹${t['amt']}',
                  style: TextStyle(color: credit ? AppColors.green : AppColors.red, fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
