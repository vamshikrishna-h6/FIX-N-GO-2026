import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final ApiService _apiService = ApiService();
  final StorageService _storage = StorageService();
  final TextEditingController _subjectCtrl = TextEditingController();
  final TextEditingController _messageCtrl = TextEditingController();
  bool _isLoading = true;
  bool _submitting = false;
  String _category = 'general';
  int? _openFaq;
  List<dynamic> _tickets = [];

  final List<Map<String, String>> _faqs = [
    {
      'q': 'How do I book a repair?',
      'a': 'Go to the home screen, select the service type, choose your device, '
          'select the issue, and confirm your booking. A technician will be assigned shortly.',
    },
    {
      'q': 'How do I track my technician?',
      'a': 'Once a technician is assigned, you can track their real-time location '
          'from the order details screen by tapping "Track Technician".',
    },
    {
      'q': 'How do I pay for a service?',
      'a': 'After your repair is completed, go to the order details and tap "Pay Now". '
          'We accept all major cards via Stripe secure payments.',
    },
    {
      'q': 'Can I cancel an order?',
      'a': 'Yes, you can cancel a pending order from the order details screen. '
          'Once a technician has started work, cancellation may not be possible.',
    },
    {
      'q': 'How do I contact support?',
      'a': 'You can create a support ticket right here! Fill in the subject and '
          'message below, select a category, and submit.',
    },
  ];

  final List<String> _categories = ['general', 'payment', 'order', 'technician', 'app_issue'];

  @override
  void initState() {
    super.initState();
    _fetchTickets();
  }

  @override
  void dispose() {
    _subjectCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  Future<void> _fetchTickets() async {
    try {
      final token = await _storage.getToken();
      _apiService.setToken(token);
      final res = await _apiService.get('/api/support/mine');
      if (!mounted) return;
      setState(() {
        _tickets = (res['data'] as List<dynamic>?) ?? [];
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  Future<void> _submitTicket() async {
    if (_subjectCtrl.text.trim().isEmpty || _messageCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in subject and message')),
      );
      return;
    }
    setState(() => _submitting = true);
    try {
      await _apiService.post('/api/support', {
        'subject': _subjectCtrl.text.trim(),
        'message': _messageCtrl.text.trim(),
        'category': _category,
      });
      _subjectCtrl.clear();
      _messageCtrl.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ticket submitted!')),
        );
      }
      _fetchTickets();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: $e')),
        );
      }
    }
    if (mounted) setState(() => _submitting = false);
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
        title: Text('Help & Support', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.brandBlue))
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // FAQs section
                  Text('Frequently Asked Questions',
                      style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textWhite)),
                  const SizedBox(height: 14),
                  ...List.generate(_faqs.length, (i) => _buildFaqItem(i)),

                  const SizedBox(height: 28),

                  // Create ticket section
                  Text('Submit a Ticket',
                      style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textWhite)),
                  const SizedBox(height: 14),
                  _buildTicketForm(),

                  const SizedBox(height: 28),

                  // My tickets
                  if (_tickets.isNotEmpty) ...[
                    Text('My Tickets',
                        style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textWhite)),
                    const SizedBox(height: 14),
                    ..._tickets.map((t) => _buildTicketCard(t as Map<String, dynamic>)),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildFaqItem(int i) {
    final faq = _faqs[i];
    final isOpen = _openFaq == i;
    return GestureDetector(
      onTap: () => setState(() => _openFaq = isOpen ? null : i),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isOpen ? AppColors.brandBlue.withValues(alpha: 0.3) : AppColors.borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(faq['q']!,
                      style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                ),
                Icon(
                  isOpen ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                  color: AppColors.textMuted,
                ),
              ],
            ),
            if (isOpen) ...[
              const SizedBox(height: 8),
              Text(faq['a']!, style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary, height: 1.5)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTicketForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category picker
          Text('Category', style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textMuted)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _categories.map((cat) {
              final selected = _category == cat;
              return GestureDetector(
                onTap: () => setState(() => _category = cat),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.brandBlue : AppColors.bgDark,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: selected ? AppColors.brandBlue : AppColors.borderColor,
                    ),
                  ),
                  child: Text(
                    cat.replaceAll('_', ' ').toUpperCase(),
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: selected ? Colors.white : AppColors.textSecondary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 14),

          // Subject
          TextField(
            controller: _subjectCtrl,
            style: GoogleFonts.poppins(color: AppColors.textPrimary, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Subject',
              hintStyle: GoogleFonts.poppins(color: AppColors.textMuted),
              filled: true,
              fillColor: AppColors.bgDark,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),

          const SizedBox(height: 10),

          // Message
          TextField(
            controller: _messageCtrl,
            maxLines: 3,
            style: GoogleFonts.poppins(color: AppColors.textPrimary, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Describe your issue...',
              hintStyle: GoogleFonts.poppins(color: AppColors.textMuted),
              filled: true,
              fillColor: AppColors.bgDark,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.all(14),
            ),
          ),

          const SizedBox(height: 14),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submitting ? null : _submitTicket,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brandBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: _submitting
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Text('Submit Ticket', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketCard(Map<String, dynamic> ticket) {
    final subject = ticket['subject'] as String? ?? '';
    final status = ticket['status'] as String? ?? 'open';
    final createdAt = ticket['createdAt'] as String? ?? '';
    final date = createdAt.length >= 10 ? createdAt.substring(0, 10) : createdAt;

    final statusColor = status == 'resolved'
        ? AppColors.brandGreen
        : status == 'closed'
            ? AppColors.textMuted
            : AppColors.statusOrange;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.confirmation_number_rounded, color: statusColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subject, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                Text(date, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textMuted)),
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
}
