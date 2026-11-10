class NearbySalon {
  const NearbySalon({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.imageUrl,
    required this.distanceKm,
    required this.rating,
    required this.reviewCountLabel,
    required this.isOpen,
    required this.openUntil,
    required this.startingPrice,
    required this.nextAvailable,
    required this.verified,
  });

  final String id;
  final String name;
  final String subtitle;
  final String imageUrl;
  final double distanceKm;
  final double rating;
  final String reviewCountLabel;
  final bool isOpen;
  final String openUntil;
  final int startingPrice;
  final String nextAvailable;
  final bool verified;
}

class PopularPlace {
  const PopularPlace({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.imageUrl,
    required this.distanceLabel,
    required this.category,
    required this.rating,
    required this.startingPrice,
    this.reviewCountLabel = '120+',
    this.slotsOpen = false,
    this.nextAvailable,
    this.verified = false,
    this.tags = const [],
  });

  final String id;
  final String name;
  final String subtitle;
  final String imageUrl;
  final String distanceLabel;
  final String category;
  final double rating;
  final int startingPrice;
  final String reviewCountLabel;
  final bool slotsOpen;
  final String? nextAvailable;
  final bool verified;
  final List<String> tags;

  bool matches(
    String query, {
    Set<String> categories = const {},
    bool slotsOpenOnly = false,
  }) {
    if (slotsOpenOnly && !slotsOpen) return false;
    if (categories.isNotEmpty && !categories.contains(category)) return false;

    final q = query.trim().toLowerCase();
    if (q.isEmpty) return true;

    final haystack = [
      name,
      subtitle,
      category,
      ...tags,
    ].join(' ').toLowerCase();
    return haystack.contains(q);
  }
}

class RecentVisit {
  const RecentVisit({
    required this.businessId,
    required this.salonName,
    required this.service,
    required this.staffName,
    required this.lastVisited,
    required this.price,
    required this.staffImageUrl,
  });

  final String businessId;
  final String salonName;
  final String service;
  final String staffName;
  final String lastVisited;
  final int price;
  final String staffImageUrl;
}

class HomeCategory {
  const HomeCategory({required this.label, this.dot = false});

  final String label;
  final bool dot;
}

abstract final class HomeMockData {
  static const categories = [
    HomeCategory(label: 'Clinics'),
    HomeCategory(label: 'Salons', dot: true),
    HomeCategory(label: 'Spa'),
    HomeCategory(label: 'Style'),
  ];

  static const nearby = NearbySalon(
    id: 'urban-studio',
    name: 'Urban Studio',
    subtitle: 'Premium Salon & Barber Atelier',
    imageUrl:
        'https://images.unsplash.com/photo-1585747860715-2ba37e788b70?auto=format&fit=crop&w=1400&q=80',
    distanceKm: 0.8,
    rating: 4.9,
    reviewCountLabel: '1.2k',
    isOpen: true,
    openUntil: '8:00 PM',
    startingPrice: 299,
    nextAvailable: '11:30 AM today',
    verified: true,
  );

  static const popular = [
    PopularPlace(
      id: 'the-groom-lab',
      name: 'The Groom Lab',
      subtitle: 'Precision fade, beard sculpt & skin',
      imageUrl:
          'https://images.unsplash.com/photo-1503951914875-452162b0f3f1?auto=format&fit=crop&w=1200&q=80',
      distanceLabel: '1.4 km',
      category: 'Barber',
      rating: 4.8,
      startingPrice: 350,
      slotsOpen: true,
      tags: ['barber', 'fade', 'beard', 'haircut'],
    ),
    PopularPlace(
      id: 'aura-wellness',
      name: 'Aura Wellness',
      subtitle: 'Aromatherapy, steam & recovery',
      imageUrl:
          'https://images.unsplash.com/photo-1540555700478-4be289fbecef?auto=format&fit=crop&w=1200&q=80',
      distanceLabel: '2.1 km',
      category: 'Spa',
      rating: 4.7,
      startingPrice: 899,
      tags: ['spa', 'massage', 'aromatherapy'],
    ),
  ];

  static const catalog = [
    PopularPlace(
      id: 'urban-studio',
      name: 'Urban Studio',
      subtitle: 'Premium Salon & Barber Atelier',
      imageUrl:
          'https://images.unsplash.com/photo-1585747860715-2ba37e788b70?auto=format&fit=crop&w=1400&q=80',
      distanceLabel: '0.8 km',
      category: 'Salon',
      rating: 4.9,
      startingPrice: 299,
      slotsOpen: true,
      reviewCountLabel: '1.2k',
      nextAvailable: '11:30 AM today',
      verified: true,
      tags: ['salon', 'barber', 'hair', 'color', 'urban studio'],
    ),
    ...popular,
    PopularPlace(
      id: 'pulse-fitness',
      name: 'Pulse Fitness',
      subtitle: 'Strength training, HIIT & personal coaching',
      imageUrl:
          'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?auto=format&fit=crop&w=1200&q=80',
      distanceLabel: '1.1 km',
      category: 'Fitness',
      rating: 4.6,
      startingPrice: 499,
      slotsOpen: true,
      tags: ['gym', 'fitness', 'workout', 'hiit'],
    ),
    PopularPlace(
      id: 'carefirst-clinic',
      name: 'CareFirst Clinic',
      subtitle: 'General physician, dental & diagnostics',
      imageUrl:
          'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?auto=format&fit=crop&w=1200&q=80',
      distanceLabel: '2.4 km',
      category: 'Clinic',
      rating: 4.5,
      startingPrice: 250,
      tags: ['clinic', 'doctor', 'dental', 'health'],
    ),
    PopularPlace(
      id: 'luxe-locks',
      name: 'Luxe Locks',
      subtitle: 'Hair color, keratin & bridal styling',
      imageUrl:
          'https://images.unsplash.com/photo-1560066984-138dadb4c035?auto=format&fit=crop&w=1200&q=80',
      distanceLabel: '1.9 km',
      category: 'Salon',
      rating: 4.7,
      startingPrice: 399,
      slotsOpen: true,
      tags: ['salon', 'hair', 'color', 'bridal'],
    ),
    PopularPlace(
      id: 'blade-and-co',
      name: 'Blade & Co',
      subtitle: 'Classic cuts, hot towel shave & grooming',
      imageUrl:
          'https://images.unsplash.com/photo-1622287162716-9541306c3f08?auto=format&fit=crop&w=1200&q=80',
      distanceLabel: '0.6 km',
      category: 'Barber',
      rating: 4.8,
      startingPrice: 280,
      tags: ['barber', 'shave', 'grooming', 'cut'],
    ),
    PopularPlace(
      id: 'iron-temple',
      name: 'Iron Temple',
      subtitle: 'Powerlifting gym with steam rooms',
      imageUrl:
          'https://images.unsplash.com/photo-1571902943202-507ec2618e8f?auto=format&fit=crop&w=1200&q=80',
      distanceLabel: '3.0 km',
      category: 'Fitness',
      rating: 4.4,
      startingPrice: 599,
      tags: ['gym', 'fitness', 'lifting', 'steam'],
    ),
    PopularPlace(
      id: 'zen-spa-house',
      name: 'Zen Spa House',
      subtitle: 'Thai massage, facials & body polish',
      imageUrl:
          'https://images.unsplash.com/photo-1544161515-4ab6ce6db874?auto=format&fit=crop&w=1200&q=80',
      distanceLabel: '2.8 km',
      category: 'Spa',
      rating: 4.6,
      startingPrice: 799,
      slotsOpen: true,
      tags: ['spa', 'massage', 'facial'],
    ),
  ];

  static List<PopularPlace> search({
    required String query,
    Set<String> categories = const {},
    bool slotsOpenOnly = false,
  }) {
    return catalog
        .where(
          (place) => place.matches(
            query,
            categories: categories,
            slotsOpenOnly: slotsOpenOnly,
          ),
        )
        .toList();
  }

  static PopularPlace? byId(String id) {
    for (final place in catalog) {
      if (place.id == id) return place;
    }
    return null;
  }
}
