import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import 'order_detail_screen.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final ApiService _apiService = ApiService();
  final StorageService _storage = StorageService();
  List<dynamic> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    try {
      final token = await _storage.getToken();
      _apiService.setToken(token);
      final res = await _apiService.get('/api/notifications/mine');
      if (!mounted) return;
      setState(() {
        _notifications = (res['data'] as List<dynamic>?) ?? [];
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  Future<void> _markAllRead() async {
    try {
      await _apiService.patch('/api/notifications/mine/read-all', {});
      _fetchNotifications();
    } catch (_) {}
  }

  Future<void> _markRead(String id) async {
    try {
      await _apiService.patch('/api/notifications/mine/$id/read', {});
    } catch (_) {}
  }

  IconData _notifIcon(String type) {
    switch (type) {
      case 'order_assigned':
        return Icons.person_search_rounded;
      case 'order_completed':
        return Icons.check_circle_rounded;
      case 'order_cancelled':
        return Icons.cancel_rounded;
      case 'payment':
        return Icons.payment_rounded;
      case 'rating':
        return Icons.star_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  Color _notifColor(String type) {
    switch (type) {
      case 'order_assigned':
        return AppColors.brandBlue;
      case 'order_completed':
        return AppColors.brandGreen;
      case 'order_cancelled':
        return AppColors.statusRed;
      case 'payment':
        return AppColors.accentCyan;
      case 'rating':
        return AppColors.starYellow;
      default:
        return AppColors.textMuted;
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
        title: Text('Notifications', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        actions: [
          if (_notifications.isNotEmpty)
            GestureDetector(
              onTap: _markAllRead,
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: Text(
                    'Mark all read',
                    style: GoogleFonts.poppins(fontSize: 13, color: AppColors.brandBlue, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.brandBlue))
          : _notifications.isEmpty
              ? _buildEmpty()
              : RefreshIndicator(
                  onRefresh: _fetchNotifications,
                  color: AppColors.brandBlue,
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                    padding: const EdgeInsets.all(20),
                    itemCount: _notifications.length,
                    itemBuilder: (context, i) => _buildNotifCard(_notifications[i]),
                  ),
                ),
    );
  }

  Widget _buildNotifCard(Map<String, dynamic> notif) {
    final type = notif['type'] as String? ?? '';
    final message = notif['message'] as String? ?? '';
    final isRead = notif['isRead'] as bool? ?? false;
    final id = notif['_id'] as String? ?? '';
    final orderId = notif['orderId'] as String? ?? '';
    final createdAt = notif['createdAt'] as String? ?? '';
    final timeAgo = createdAt.length >= 10 ? createdAt.substring(0, 10) : createdAt;

    return GestureDetector(
      onTap: () {
        if (!isRead) _markRead(id);
        if (orderId.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => OrderDetailScreen(orderId: orderId)),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isRead ? AppColors.bgCard : AppColors.bgCardLight,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isRead ? AppColors.borderColor : AppColors.brandBlue.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: _notifColor(type).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(_notifIcon(type), color: _notifColor(type), size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: isRead ? FontWeight.w400 : FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(timeAgo, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textMuted)),
                ],
              ),
            ),
            if (!isRead)
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 6),
                decoration: const BoxDecoration(color: AppColors.brandBlue, shape: BoxShape.circle),
              ),
          ],
        ),
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
            child: const Icon(Icons.notifications_off_rounded, size: 36, color: AppColors.textMuted),
          ),
          const SizedBox(height: 16),
          Text('No notifications', style: GoogleFonts.poppins(fontSize: 15, color: AppColors.textMuted)),
        ],
      ),
    );
  }
}
