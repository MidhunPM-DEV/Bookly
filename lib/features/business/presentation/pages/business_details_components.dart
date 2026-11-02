part of 'business_details_page.dart';

class _DetailsHeader extends StatelessWidget {
  const _DetailsHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(12, 4, 16, 8),
    child: Row(
      children: [
        IconButton(
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
        ),
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: AppColors.lime,
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Icon(Icons.auto_awesome, size: 12),
        ),
        const SizedBox(width: 6),
        const Text('BOOKLY', style: TextStyle(fontWeight: FontWeight.w800)),
        const SizedBox(width: 8),
        const Text(
          'Business Details',
          style: TextStyle(color: AppColors.muted, fontWeight: FontWeight.w600),
        ),
        const Spacer(),
        const CircleAvatar(
          radius: 16,
          backgroundImage: NetworkImage(
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=200&q=80',
          ),
        ),
      ],
    ),
  );
}

class _HeroImage extends StatelessWidget {
  const _HeroImage({
    required this.business,
    required this.favorite,
    required this.onFavorite,
    required this.onShare,
  });

  final Business business;
  final bool favorite;
  final VoidCallback onFavorite;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(22),
    child: SizedBox(
      height: 210,
      child: Stack(
        fit: StackFit.expand,
        children: [
          RemoteImage(url: business.imageUrl),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Color(0x66000000)],
              ),
            ),
          ),
          Positioned(
            top: 12,
            right: 12,
            child: Row(
              children: [
                _RoundIcon(
                  icon: favorite ? Icons.favorite : Icons.favorite_border,
                  color: favorite ? Colors.red : AppColors.ink,
                  onTap: onFavorite,
                ),
                const SizedBox(width: 8),
                _RoundIcon(icon: Icons.ios_share_rounded, onTap: onShare),
              ],
            ),
          ),
          Positioned(
            left: 12,
            bottom: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.lime,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                business.isOpen
                    ? 'OPEN TODAY  •  UNTIL ${business.openUntil}'
                    : 'CLOSED',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 11,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _RoundIcon extends StatelessWidget {
  const _RoundIcon({required this.icon, required this.onTap, this.color});

  final IconData icon;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: CircleAvatar(
      radius: 18,
      backgroundColor: Colors.white,
      child: Icon(icon, size: 18, color: color ?? AppColors.ink),
    ),
  );
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Expanded(
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            Icon(icon, size: 22, color: AppColors.ink),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            ),
          ],
        ),
      ),
    ),
  );
}

class _DetailsTabs extends StatelessWidget {
  const _DetailsTabs({required this.index, required this.onChanged});

  final int index;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    const labels = ['Overview', 'Services', 'Reviews'];
    return Row(
      children: List.generate(
        labels.length,
        (i) => Expanded(
          child: GestureDetector(
            onTap: () => onChanged(i),
            child: Column(
              children: [
                Text(
                  labels[i],
                  style: TextStyle(
                    fontWeight: i == index ? FontWeight.w800 : FontWeight.w600,
                    color: i == index ? AppColors.ink : AppColors.muted,
                  ),
                ),
                const SizedBox(height: 8),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  height: 3,
                  margin: const EdgeInsets.symmetric(horizontal: 18),
                  decoration: BoxDecoration(
                    color: i == index ? AppColors.lime : Colors.transparent,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({required this.business});

  final Business business;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'About',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
      ),
      const SizedBox(height: 8),
      Text(
        business.about,
        style: const TextStyle(height: 1.45, color: AppColors.mutedDark),
      ),
      const SizedBox(height: 16),
      const Text(
        'Hours',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
      ),
      const SizedBox(height: 6),
      Text(business.hours, style: const TextStyle(fontWeight: FontWeight.w600)),
      const SizedBox(height: 16),
      const Text(
        'Amenities',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
      ),
      const SizedBox(height: 8),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: business.amenities
            .map(
              (item) => Chip(
                label: Text(item),
                backgroundColor: AppColors.surface,
                side: const BorderSide(color: AppColors.chipOutline),
              ),
            )
            .toList(),
      ),
      const SizedBox(height: 16),
      const Text(
        'Address',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
      ),
      const SizedBox(height: 6),
      Text(
        business.address,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ],
  );
}
