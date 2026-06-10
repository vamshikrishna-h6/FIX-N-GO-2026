import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../widgets/common_widgets.dart';

class PartsTrackingScreen extends StatefulWidget {
  final String jobId;
  const PartsTrackingScreen({super.key, required this.jobId});

  @override
  State<PartsTrackingScreen> createState() => _PartsTrackingScreenState();
}

class _PartsTrackingScreenState extends State<PartsTrackingScreen> {
  List<Map<String, dynamic>> _parts = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadParts();
  }

  Future<void> _loadParts() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('job_parts_${widget.jobId}');
    if (data != null) {
      _parts = (jsonDecode(data) as List<dynamic>).cast<Map<String, dynamic>>();
    }
    setState(() => _loading = false);
  }

  Future<void> _saveParts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('job_parts_${widget.jobId}', jsonEncode(_parts));
  }

  void _addPart() {
    final nameCtrl = TextEditingController();
    final qtyCtrl = TextEditingController(text: '1');
    final costCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Add Part/Material', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            TextField(
              controller: nameCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Part name (e.g. Screen Guard)',
                prefixIcon: Icon(Icons.build_circle_outlined),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: qtyCtrl,
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Qty',
                      prefixIcon: Icon(Icons.numbers_rounded),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: costCtrl,
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Cost (₹)',
                      prefixIcon: Icon(Icons.currency_rupee_rounded),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              label: 'Add Part',
              color: AppColors.green,
              icon: Icons.add_rounded,
              onTap: () {
                if (nameCtrl.text.trim().isEmpty) return;
                final part = {
                  'id': DateTime.now().millisecondsSinceEpoch.toString(),
                  'name': nameCtrl.text.trim(),
                  'quantity': int.tryParse(qtyCtrl.text) ?? 1,
                  'cost': int.tryParse(costCtrl.text) ?? 0,
                  'used': false,
                };
                setState(() => _parts.add(part));
                _saveParts();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _toggleUsed(int index) {
    setState(() => _parts[index]['used'] = !(_parts[index]['used'] ?? false));
    _saveParts();
  }

  void _removePart(int index) {
    setState(() => _parts.removeAt(index));
    _saveParts();
  }

  int get _totalCost {
    int total = 0;
    for (final p in _parts) {
      total += ((p['cost'] as int?) ?? 0) * ((p['quantity'] as int?) ?? 1);
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Parts & Materials'),
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
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded, color: Colors.white),
            onPressed: _addPart,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.red, strokeWidth: 2))
          : Column(
              children: [
                if (_parts.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.green.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Parts Cost', style: TextStyle(color: AppColors.green, fontWeight: FontWeight.w600)),
                        Text('₹$_totalCost', style: const TextStyle(color: AppColors.green, fontWeight: FontWeight.w800, fontSize: 18)),
                      ],
                    ),
                  ),
                Expanded(
                  child: _parts.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.inventory_2_outlined, color: AppColors.grey, size: 48),
                              const SizedBox(height: 12),
                              const Text('No parts tracked', style: TextStyle(color: AppColors.grey)),
                              const SizedBox(height: 4),
                              const Text('Track parts and materials used', style: TextStyle(color: AppColors.grey, fontSize: 12)),
                              const SizedBox(height: 20),
                              GestureDetector(
                                onTap: _addPart,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: AppColors.red,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Text('Add Part', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _parts.length,
                          itemBuilder: (context, index) {
                            final part = _parts[index];
                            final used = part['used'] == true;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: AppColors.card,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: used ? AppColors.green.withValues(alpha: 0.3) : AppColors.border,
                                ),
                              ),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => _toggleUsed(index),
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: used ? AppColors.green : Colors.transparent,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(color: used ? AppColors.green : AppColors.grey),
                                      ),
                                      child: used ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          part['name'],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            decoration: used ? TextDecoration.lineThrough : null,
                                          ),
                                        ),
                                        Text(
                                          'Qty: ${part['quantity']} • ₹${part['cost']} each',
                                          style: const TextStyle(color: AppColors.grey, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '₹${(part['cost'] as int) * (part['quantity'] as int)}',
                                    style: const TextStyle(color: AppColors.green, fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () => _removePart(index),
                                    child: const Icon(Icons.close_rounded, color: AppColors.grey, size: 18),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
