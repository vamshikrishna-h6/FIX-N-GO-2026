import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import 'order_detail_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ApiService _apiService = ApiService();
  final StorageService _storage = StorageService();
  List<Map<String, dynamic>> _allOrders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchOrders();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchOrders() async {
    try {
      final token = await _storage.getToken();
      _apiService.setToken(token);
      final orders = await _apiService.getOrders();
      if (!mounted) return;
      setState(() {
        _allOrders = orders.cast<Map<String, dynamic>>();
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  List<Map<String, dynamic>> _filterOrders(String category) {
    return _allOrders.where((o) {
      final status = (o['status'] as String?) ?? '';
      switch (category) {
        case 'active':
          return status == 'pending' || status == 'assigned' || status == 'in_progress';
        case 'completed':
          return status == 'completed';
        case 'cancelled':
          return status == 'cancelled';
        default:
          return false;
      }
    }).toList();
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'pending':
        return AppColors.statusOrange;
      case 'assigned':
      case 'in_progress':
        return AppColors.brandBlue;
      case 'completed':
        return AppColors.brandGreen;
      case 'cancelled':
        return AppColors.statusRed;
      default:
        return AppColors.textMuted;
    }
  }

  IconData _issueIcon(String issue) {
    final lower = issue.toLowerCase();
    if (lower.contains('screen') || lower.contains('display')) return Icons.broken_image_rounded;
    if (lower.contains('battery')) return Icons.battery_alert_rounded;
    if (lower.contains('charging') || lower.contains('port')) return Icons.usb_rounded;
    if (lower.contains('speaker') || lower.contains('mic')) return Icons.volume_up_rounded;
    if (lower.contains('glass') || lower.contains('back')) return Icons.shield_rounded;
    if (lower.contains('camera')) return Icons.camera_alt_rounded;
    if (lower.contains('water')) return Icons.water_drop_rounded;
    return Icons.build_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Text(
                'My Orders',
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textWhite,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: AppColors.bgCard,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderColor),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: AppColors.brandBlue,
                  borderRadius: BorderRadius.circular(10),
                ),
                indicatorPadding: const EdgeInsets.all(4),
                labelColor: Colors.white,
                unselectedLabelColor: AppColors.textMuted,
                labelStyle: GoogleFonts.poppins(
                    fontSize: 13, fontWeight: FontWeight.w600),
                unselectedLabelStyle:
                    GoogleFonts.poppins(fontSize: 13),
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(text: 'Active'),
                  Tab(text: 'Completed'),
                  Tab(text: 'Cancelled'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.brandBlue))
                  : TabBarView(
                      controller: _tabController,
                      children: [
                        _buildOrdersList(_filterOrders('active'), isActive: true),
                        _buildOrdersList(_filterOrders('completed')),
                        _buildOrdersList(_filterOrders('cancelled')),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersList(List<Map<String, dynamic>> orders,
      {bool isActive = false}) {
    if (orders.isEmpty) {
      return _buildEmptyState('No orders yet');
    }
    return RefreshIndicator(
      onRefresh: _fetchOrders,
      color: AppColors.brandBlue,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        itemCount: orders.length,
        itemBuilder: (context, i) {
          final order = orders[i];
          return _buildOrderCard(order, isActive: isActive);
        },
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order, {bool isActive = false}) {
    final status = (order['status'] as String?) ?? 'pending';
    final brand = order['brand'] as String? ?? '';
    final model = order['model'] as String? ?? '';
    final total = order['total'] as num? ?? 0;
    final issues = (order['issues'] as List<dynamic>?)?.cast<String>() ?? [];
    final firstIssue = issues.isNotEmpty ? issues[0] : 'Repair';
    final orderId = order['_id'] as String? ?? '';
    final createdAt = order['createdAt'] as String? ?? '';
    final date = createdAt.length >= 10 ? createdAt.substring(0, 10) : createdAt;
    final techName = order['technician'] as String? ?? '';
    final color = _statusColor(status);

    return GestureDetector(
      onTap: () {
        if (orderId.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => OrderDetailScreen(orderId: orderId)),
          ).then((_) => _fetchOrders());
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive ? AppColors.brandBlue.withValues(alpha: 0.3) : AppColors.borderColor,
          ),
          boxShadow: isActive
              ? [BoxShadow(
                  color: AppColors.brandBlue.withValues(alpha: 0.08),
                  blurRadius: 16)]
              : [],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(_issueIcon(firstIssue), color: color, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(firstIssue,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textWhite,
                          )),
                      Text('$brand $model',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          )),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('₹$total',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textWhite,
                        )),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        status.replaceAll('_', ' ').toUpperCase(),
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(height: 1, color: AppColors.borderColor),
            const SizedBox(height: 10),
            Row(
              children: [
                if (techName.isNotEmpty) ...[
                  const Icon(Icons.person_rounded, size: 14, color: AppColors.textMuted),
                  const SizedBox(width: 4),
                  Text(techName,
                      style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textMuted)),
                ],
                const Spacer(),
                if (orderId.length >= 8)
                  Text('#${orderId.substring(orderId.length - 8)}',
                      style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textMuted)),
                const SizedBox(width: 8),
                const Icon(Icons.access_time_rounded, size: 13, color: AppColors.textMuted),
                const SizedBox(width: 3),
                Text(date,
                    style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textMuted)),
              ],
            ),
            if (isActive) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (orderId.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => OrderDetailScreen(orderId: orderId)),
                      ).then((_) => _fetchOrders());
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brandBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                  child: Text('View Details',
                      style: GoogleFonts.poppins(
                          fontSize: 13, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
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
            child: const Icon(Icons.receipt_long_rounded,
                size: 36, color: AppColors.textMuted),
          ),
          const SizedBox(height: 16),
          Text(message,
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: AppColors.textMuted,
                fontWeight: FontWeight.w500,
              )),
        ],
      ),
    );
  }
}
