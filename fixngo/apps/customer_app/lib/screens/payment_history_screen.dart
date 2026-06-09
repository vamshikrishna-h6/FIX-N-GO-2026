import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  final ApiService _apiService = ApiService();
  final StorageService _storage = StorageService();
  List<dynamic> _payments = [];
  bool _isLoading = true;
  int _page = 1;
  int _totalPages = 1;

  @override
  void initState() {
    super.initState();
    _fetchPayments();
  }

  Future<void> _fetchPayments() async {
    try {
      final token = await _storage.getToken();
      _apiService.setToken(token);
      final res = await _apiService.get('/api/payments/history?page=$_page&limit=20');
      if (!mounted) return;
      setState(() {
        _payments = (res['data'] as List<dynamic>?) ?? [];
        _totalPages = (res['pages'] as num?)?.toInt() ?? 1;
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
        title: Text('Payment History', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.brandBlue))
          : _payments.isEmpty
              ? _buildEmpty()
              : Column(
                  children: [
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _fetchPayments,
                        color: AppColors.brandBlue,
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                          padding: const EdgeInsets.all(20),
                          itemCount: _payments.length,
                          itemBuilder: (context, i) => _buildPaymentCard(_payments[i]),
                        ),
                      ),
                    ),
                    if (_totalPages > 1) _buildPagination(),
                  ],
                ),
    );
  }

  Widget _buildPaymentCard(Map<String, dynamic> payment) {
    final amount = payment['amount'] as num? ?? 0;
    final status = payment['status'] as String? ?? 'pending';
    final createdAt = payment['createdAt'] as String? ?? '';
    final date = createdAt.length >= 10 ? createdAt.substring(0, 10) : createdAt;
    final orderId = payment['orderId'] as String? ?? '';

    Color statusColor;
    switch (status) {
      case 'succeeded':
      case 'completed':
        statusColor = AppColors.brandGreen;
        break;
      case 'pending':
        statusColor = AppColors.statusOrange;
        break;
      case 'failed':
        statusColor = AppColors.statusRed;
        break;
      default:
        statusColor = AppColors.textMuted;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.payment_rounded, color: statusColor, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '₹${(amount / 100).toStringAsFixed(0)}',
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textWhite),
                ),
                Text(date, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textMuted)),
                if (orderId.isNotEmpty)
                  Text('Order: ${orderId.substring(orderId.length > 8 ? orderId.length - 8 : 0)}',
                      style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textMuted)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status.toUpperCase(),
              style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: statusColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPagination() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: _page > 1
                ? () {
                    setState(() { _page--; _isLoading = true; });
                    _fetchPayments();
                  }
                : null,
            icon: Icon(Icons.chevron_left_rounded, color: _page > 1 ? AppColors.brandBlue : AppColors.textMuted),
          ),
          Text('$_page / $_totalPages', style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textPrimary)),
          IconButton(
            onPressed: _page < _totalPages
                ? () {
                    setState(() { _page++; _isLoading = true; });
                    _fetchPayments();
                  }
                : null,
            icon: Icon(Icons.chevron_right_rounded, color: _page < _totalPages ? AppColors.brandBlue : AppColors.textMuted),
          ),
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
            child: const Icon(Icons.payment_rounded, size: 36, color: AppColors.textMuted),
          ),
          const SizedBox(height: 16),
          Text('No payments yet', style: GoogleFonts.poppins(fontSize: 15, color: AppColors.textMuted)),
        ],
      ),
    );
  }
}
