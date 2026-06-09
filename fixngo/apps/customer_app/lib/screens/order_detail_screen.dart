import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import '../services/payment_service.dart';
import 'rating_screen.dart';
import 'track_technician_screen.dart';

class OrderDetailScreen extends StatefulWidget {
  final String orderId;
  const OrderDetailScreen({super.key, required this.orderId});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final ApiService _apiService = ApiService();
  final StorageService _storage = StorageService();
  final PaymentService _paymentService = PaymentService();
  Map<String, dynamic>? _order;
  bool _isLoading = true;
  bool _cancelling = false;

  @override
  void initState() {
    super.initState();
    _fetchOrder();
  }

  Future<void> _fetchOrder() async {
    try {
      final token = await _storage.getToken();
      _apiService.setToken(token);
      final res = await _apiService.getOrderById(widget.orderId);
      if (!mounted) return;
      setState(() {
        _order = res['data'] as Map<String, dynamic>? ?? res;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  Future<void> _cancelOrder() async {
    setState(() => _cancelling = true);
    try {
      final token = await _storage.getToken();
      _apiService.setToken(token);
      await _apiService.patch('/api/orders/${widget.orderId}/status', {'status': 'cancelled'});
      await _fetchOrder();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order cancelled')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to cancel: $e')),
        );
      }
    }
    if (mounted) setState(() => _cancelling = false);
  }

  Future<void> _payForOrder() async {
    final total = _order?['total'] as num? ?? 0;
    final success = await _paymentService.processPayment(widget.orderId, total.toInt());
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(success ? 'Payment successful!' : 'Payment failed')),
      );
      if (success) _fetchOrder();
    }
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

  IconData _statusIcon(String status) {
    switch (status) {
      case 'pending':
        return Icons.schedule_rounded;
      case 'assigned':
        return Icons.person_search_rounded;
      case 'in_progress':
        return Icons.build_rounded;
      case 'completed':
        return Icons.check_circle_rounded;
      case 'cancelled':
        return Icons.cancel_rounded;
      default:
        return Icons.info_rounded;
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
        title: Text('Order Details', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.brandBlue))
          : _order == null
              ? Center(
                  child: Text('Order not found', style: GoogleFonts.poppins(color: AppColors.textMuted)),
                )
              : _buildContent(),
    );
  }

  Widget _buildContent() {
    final status = _order!['status'] as String? ?? 'pending';
    final brand = _order!['brand'] as String? ?? '';
    final model = _order!['model'] as String? ?? '';
    final issues = (_order!['issues'] as List<dynamic>?)?.cast<String>() ?? [];
    final total = _order!['total'] as num? ?? 0;
    final techName = _order!['technician'] as String? ?? '';
    final createdAt = _order!['createdAt'] as String? ?? '';
    final statusHistory = (_order!['statusHistory'] as List<dynamic>?) ?? [];
    final checklist = (_order!['checklist'] as List<dynamic>?) ?? [];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_statusColor(status), _statusColor(status).withValues(alpha: 0.6)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(_statusIcon(status), color: Colors.white, size: 36),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        status.replaceAll('_', ' ').toUpperCase(),
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      if (techName.isNotEmpty)
                        Text(
                          'Technician: $techName',
                          style: GoogleFonts.poppins(fontSize: 13, color: Colors.white70),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Device info
          _SectionCard(
            title: 'Device',
            children: [
              _InfoRow(label: 'Brand', value: brand),
              _InfoRow(label: 'Model', value: model),
            ],
          ),

          const SizedBox(height: 12),

          // Issues
          _SectionCard(
            title: 'Issues',
            children: issues.map((issue) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  const Icon(Icons.circle, size: 6, color: AppColors.brandBlue),
                  const SizedBox(width: 10),
                  Text(issue, style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textPrimary)),
                ],
              ),
            )).toList(),
          ),

          const SizedBox(height: 12),

          // Payment
          _SectionCard(
            title: 'Payment',
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total', style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary)),
                  Text(
                    '₹$total',
                    style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textWhite),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Timeline
          if (statusHistory.isNotEmpty) ...[
            _SectionCard(
              title: 'Timeline',
              children: statusHistory.map<Widget>((entry) {
                final note = entry['note'] as String? ?? entry['status'] as String? ?? '';
                final ts = entry['timestamp'] as String? ?? '';
                final date = ts.length >= 10 ? ts.substring(0, 10) : ts;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        margin: const EdgeInsets.only(top: 5),
                        decoration: BoxDecoration(
                          color: AppColors.brandBlue,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(note, style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textPrimary)),
                            Text(date, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textMuted)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
          ],

          // Checklist
          if (checklist.isNotEmpty) ...[
            _SectionCard(
              title: 'Checklist',
              children: checklist.map<Widget>((item) {
                final label = item['label'] as String? ?? item.toString();
                final done = item['done'] as bool? ?? false;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Icon(
                        done ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                        size: 20,
                        color: done ? AppColors.brandGreen : AppColors.textMuted,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(label, style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textPrimary)),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
          ],

          if (createdAt.isNotEmpty) ...[
            Text(
              'Created: ${createdAt.length >= 10 ? createdAt.substring(0, 10) : createdAt}',
              style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textMuted),
            ),
            const SizedBox(height: 20),
          ],

          // Action buttons
          ..._buildActions(status),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  List<Widget> _buildActions(String status) {
    final actions = <Widget>[];

    if (status == 'assigned' || status == 'in_progress') {
      actions.add(
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TrackTechnicianScreen(orderId: widget.orderId)),
              );
            },
            icon: const Icon(Icons.location_on_rounded),
            label: Text('Track Technician', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brandBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      );
      actions.add(const SizedBox(height: 10));
    }

    if (status == 'completed') {
      actions.add(
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _payForOrder,
            icon: const Icon(Icons.payment_rounded),
            label: Text('Pay Now', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brandGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      );
      actions.add(const SizedBox(height: 10));
      actions.add(
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              final techUser = _order!['technicianUser'];
              final techId = techUser is Map ? techUser['_id'] as String? ?? '' : techUser?.toString() ?? '';
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RatingScreen(orderId: widget.orderId, technicianId: techId),
                ),
              );
            },
            icon: const Icon(Icons.star_rounded),
            label: Text('Rate Technician', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.starYellow,
              side: const BorderSide(color: AppColors.starYellow),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      );
      actions.add(const SizedBox(height: 10));
    }

    if (status == 'pending') {
      actions.add(
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _cancelling ? null : _cancelOrder,
            icon: _cancelling
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.cancel_rounded),
            label: Text(_cancelling ? 'Cancelling...' : 'Cancel Order',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.statusRed,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      );
    }

    return actions;
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _SectionCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textMuted)),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary)),
          Text(value, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}
