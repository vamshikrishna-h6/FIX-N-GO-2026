import 'package:flutter/material.dart';
import '../api_service_new.dart';
import '../widgets/common_widgets.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final _api = ApiService();
  DateTime _selectedDate = DateTime.now();
  List<dynamic> _appointments = [];
  bool _loading = true;
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    _fetchAppointments();
  }

  Future<void> _fetchAppointments() async {
    setState(() => _loading = true);
    final jobs = await _api.getMyJobs();
    if (!mounted) return;
    setState(() {
      _appointments = jobs;
      _loading = false;
    });
  }

  List<dynamic> get _todayAppointments {
    return _appointments.where((job) {
      final dateStr = job['scheduledDate'] ?? job['createdAt'] ?? '';
      if (dateStr.isEmpty) return false;
      try {
        final date = DateTime.parse(dateStr);
        return date.year == _selectedDate.year &&
            date.month == _selectedDate.month &&
            date.day == _selectedDate.day;
      } catch (_) {
        return false;
      }
    }).toList();
  }

  void _changeMonth(int delta) {
    setState(() {
      _selectedMonth += delta;
      if (_selectedMonth > 12) {
        _selectedMonth = 1;
        _selectedYear++;
      } else if (_selectedMonth < 1) {
        _selectedMonth = 12;
        _selectedYear--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Schedule'),
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
          : Column(
              children: [
                _buildCalendar(),
                const SizedBox(height: 8),
                Expanded(child: _buildAppointmentList()),
              ],
            ),
    );
  }

  Widget _buildCalendar() {
    final daysInMonth = DateTime(_selectedYear, _selectedMonth + 1, 0).day;
    final firstDay = DateTime(_selectedYear, _selectedMonth, 1).weekday;
    final monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => _changeMonth(-1),
                child: const Icon(Icons.chevron_left_rounded, color: Colors.white),
              ),
              Text(
                '${monthNames[_selectedMonth - 1]} $_selectedYear',
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
              ),
              GestureDetector(
                onTap: () => _changeMonth(1),
                child: const Icon(Icons.chevron_right_rounded, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: ['M', 'T', 'W', 'T', 'F', 'S', 'S']
                .map((d) => Expanded(
                      child: Center(
                        child: Text(d, style: const TextStyle(color: AppColors.grey, fontSize: 12, fontWeight: FontWeight.w600)),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 8),
          ...List.generate(6, (week) {
            return Row(
              children: List.generate(7, (day) {
                final dayNum = week * 7 + day - firstDay + 2;
                if (dayNum < 1 || dayNum > daysInMonth) {
                  return const Expanded(child: SizedBox(height: 36));
                }
                final date = DateTime(_selectedYear, _selectedMonth, dayNum);
                final isSelected = date.day == _selectedDate.day &&
                    date.month == _selectedDate.month &&
                    date.year == _selectedDate.year;
                final isToday = date.day == DateTime.now().day &&
                    date.month == DateTime.now().month &&
                    date.year == DateTime.now().year;
                final hasAppointment = _appointments.any((job) {
                  final dateStr = job['scheduledDate'] ?? job['createdAt'] ?? '';
                  if (dateStr.isEmpty) return false;
                  try {
                    final d = DateTime.parse(dateStr);
                    return d.year == date.year && d.month == date.month && d.day == date.day;
                  } catch (_) {
                    return false;
                  }
                });

                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedDate = date),
                    child: Container(
                      height: 36,
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.red : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: isToday && !isSelected ? Border.all(color: AppColors.red) : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$dayNum',
                            style: TextStyle(
                              color: isSelected ? Colors.white : (isToday ? AppColors.red : Colors.white),
                              fontSize: 13,
                              fontWeight: isSelected || isToday ? FontWeight.w700 : FontWeight.w400,
                            ),
                          ),
                          if (hasAppointment)
                            Container(
                              width: 4,
                              height: 4,
                              margin: const EdgeInsets.only(top: 1),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected ? Colors.white : AppColors.green,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAppointmentList() {
    final appointments = _todayAppointments;

    if (appointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.event_available_rounded, color: AppColors.grey, size: 48),
            const SizedBox(height: 12),
            Text(
              'No appointments on ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
              style: const TextStyle(color: AppColors.grey, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final job = appointments[index];
        return Container(
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
                width: 4,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.green,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job['serviceType'] ?? 'Repair Job',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      job['location']?['address'] ?? 'Location TBD',
                      style: const TextStyle(color: AppColors.grey, fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              StatusBadge(status: job['status'] ?? 'pending'),
            ],
          ),
        );
      },
    );
  }
}
