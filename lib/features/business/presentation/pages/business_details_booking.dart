part of 'business_details_page.dart';

class _ServicesTab extends StatelessWidget {
  const _ServicesTab({
    required this.business,
    required this.selectedIds,
    required this.selectedStaffId,
    required this.onToggleService,
    required this.onSelectStaff,
  });

  final Business business;
  final Set<String> selectedIds;
  final String? selectedStaffId;
  final ValueChanged<String> onToggleService;
  final ValueChanged<String> onSelectStaff;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          const Expanded(
            child: Text(
              'Curated Services',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
          ),
          Text(
            '${business.services.length} available',
            style: const TextStyle(color: AppColors.muted),
          ),
        ],
      ),
      const SizedBox(height: 12),
      ...business.services.map(
        (service) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _ServiceCard(
            service: service,
            selected: selectedIds.contains(service.id),
            onToggle: () => onToggleService(service.id),
          ),
        ),
      ),
      const SizedBox(height: 8),
      Row(
        children: [
          const Expanded(
            child: Text(
              'Our Team',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
          ),
          GestureDetector(
            onTap: () => _showTeamSheet(context),
            child: const Text(
              'View all →',
              style: TextStyle(
                color: AppColors.accentGreen,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 4),
      const Text(
        'Choose your preferred specialist',
        style: TextStyle(color: AppColors.mutedDark),
      ),
      const SizedBox(height: 14),
      SizedBox(
        height: 132,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: business.team.length,
          separatorBuilder: (_, _) => const SizedBox(width: 16),
          itemBuilder: (context, index) {
            final member = business.team[index];
            final selected = member.id == selectedStaffId;
            return GestureDetector(
              onTap: () => onSelectStaff(member.id),
              child: SizedBox(
                width: 92,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selected ? AppColors.lime : Colors.transparent,
                          width: 3,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 36,
                        backgroundImage: NetworkImage(member.imageUrl),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      member.name,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    Text(
                      member.role,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.muted,
                      ),
                    ),
                    Text(
                      '${member.rating} ★',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ],
  );

  Future<void> _showTeamSheet(BuildContext context) =>
      showModalBottomSheet<void>(
        context: context,
        backgroundColor: AppColors.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (context) => Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Our Team',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              ...business.team.map(
                (member) => ListTile(
                  onTap: () {
                    onSelectStaff(member.id);
                    Navigator.pop(context);
                  },
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(member.imageUrl),
                  ),
                  title: Text(
                    member.name,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  subtitle: Text(member.role),
                  trailing: Text('${member.rating} ★'),
                ),
              ),
            ],
          ),
        ),
      );
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({
    required this.service,
    required this.selected,
    required this.onToggle,
  });

  final BusinessService service;
  final bool selected;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) => AnimatedContainer(
    duration: const Duration(milliseconds: 180),
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
    decoration: BoxDecoration(
      color: selected ? const Color(0xFFF4FBE6) : AppColors.surface,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: selected ? const Color(0xFFD7ECA8) : const Color(0xFFE8E4DE),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                service.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Text(
              '₹${service.price}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          service.description,
          style: const TextStyle(color: AppColors.mutedDark),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Icon(Icons.schedule, size: 16, color: AppColors.mutedDark),
            const SizedBox(width: 4),
            Text(
              '${service.durationMinutes} min',
              style: const TextStyle(color: AppColors.mutedDark),
            ),
            const Spacer(),
            OutlinedButton(
              onPressed: onToggle,
              style: OutlinedButton.styleFrom(
                backgroundColor: selected ? AppColors.lime : null,
                foregroundColor: AppColors.ink,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(selected ? 'Selected' : 'Select'),
            ),
          ],
        ),
      ],
    ),
  );
}

class _ReviewsTab extends StatelessWidget {
  const _ReviewsTab({required this.business});

  final Business business;

  @override
  Widget build(BuildContext context) => Column(
    children: business.reviews
        .map(
          (review) => Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      review.author,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.star_rounded,
                      size: 16,
                      color: Color(0xFFF5C518),
                    ),
                    Text(
                      '${review.rating}',
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(review.comment),
                const SizedBox(height: 6),
                Text(
                  review.dateLabel,
                  style: const TextStyle(color: AppColors.muted, fontSize: 12),
                ),
              ],
            ),
          ),
        )
        .toList(),
  );
}

class _BookingBar extends StatelessWidget {
  const _BookingBar({
    required this.count,
    required this.total,
    required this.onBook,
  });

  final int count;
  final int total;
  final VoidCallback onBook;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.fromLTRB(
      20,
      12,
      20,
      12 + MediaQuery.paddingOf(context).bottom,
    ),
    decoration: const BoxDecoration(
      color: AppColors.surface,
      boxShadow: [
        BoxShadow(
          color: Color(0x14000000),
          blurRadius: 16,
          offset: Offset(0, -4),
        ),
      ],
    ),
    child: Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$count ${count == 1 ? 'service' : 'services'} selected'),
            Text(
              count == 0 ? '₹0' : '₹$total',
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
            ),
          ],
        ),
        const Spacer(),
        FilledButton(
          onPressed: onBook,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.lime,
            foregroundColor: AppColors.ink,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: const Text(
            'Book appointment',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
      ],
    ),
  );
}
