import 'package:bookly/core/theme/app_colors.dart';
import 'package:bookly/features/bookings/booking_store.dart';
import 'package:bookly/features/business/data/models/business.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<void> showBookingSheet(
  BuildContext context, {
  required Business business,
  required List<BusinessService> services,
  required TeamMember? staff,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) => _BookingSheet(
      business: business,
      services: services,
      staff: staff,
    ),
  );
}

class _BookingSheet extends StatefulWidget {
  const _BookingSheet({
    required this.business,
    required this.services,
    required this.staff,
  });

  final Business business;
  final List<BusinessService> services;
  final TeamMember? staff;

  @override
  State<_BookingSheet> createState() => _BookingSheetState();
}

class _BookingSheetState extends State<_BookingSheet> {
  late DateTime _date;
  String _time = '11:30 AM';

  static const _slots = [
    '10:00 AM',
    '10:30 AM',
    '11:00 AM',
    '11:30 AM',
    '12:00 PM',
    '2:00 PM',
    '3:30 PM',
    '5:00 PM',
    '6:30 PM',
  ];

  int get _total => widget.services.fold(0, (sum, service) => sum + service.price);

  @override
  void initState() {
    super.initState();
    _date = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final days = List.generate(7, (index) => DateTime.now().add(Duration(days: index)));
    final staffName = widget.staff?.name ?? 'Any specialist';

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 16 + MediaQuery.paddingOf(context).bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.chipOutline,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Book appointment', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(
            '${widget.business.name} · $staffName',
            style: const TextStyle(color: AppColors.mutedDark, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          const Text('Date', style: TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          SizedBox(
            height: 72,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: days.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final day = days[index];
                final selected = DateUtils.isSameDay(day, _date);
                return GestureDetector(
                  onTap: () => setState(() => _date = day),
                  child: Container(
                    width: 58,
                    decoration: BoxDecoration(
                      color: selected ? AppColors.ink : AppColors.background,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('EEE').format(day).toUpperCase(),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: selected ? Colors.white70 : AppColors.muted,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${day.day}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: selected ? Colors.white : AppColors.ink,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          const Text('Time', style: TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _slots.map((slot) {
              final selected = slot == _time;
              return ChoiceChip(
                label: Text(slot),
                selected: selected,
                onSelected: (_) => setState(() => _time = slot),
                selectedColor: AppColors.lime,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
                side: BorderSide(color: selected ? AppColors.lime : AppColors.chipOutline),
              );
            }).toList(),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.services.length} ${widget.services.length == 1 ? 'service' : 'services'}',
                    style: const TextStyle(color: AppColors.mutedDark, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '₹$_total',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
              const Spacer(),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.lime,
                  foregroundColor: AppColors.ink,
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () {
                  BookingStore.instance.add(
                    Booking(
                      businessId: widget.business.id,
                      businessName: widget.business.name,
                      serviceNames: widget.services.map((service) => service.name).toList(),
                      staffName: staffName,
                      dateLabel: DateFormat('EEE, d MMM').format(_date),
                      timeLabel: _time,
                      total: _total,
                    ),
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: Text('Booked ${widget.business.name} on ${DateFormat('EEE d MMM').format(_date)} at $_time'),
                    ),
                  );
                },
                child: const Text('Confirm booking', style: TextStyle(fontWeight: FontWeight.w800)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
