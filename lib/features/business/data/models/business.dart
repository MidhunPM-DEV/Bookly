class BusinessService {
  const BusinessService({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.durationMinutes,
  });

  final String id;
  final String name;
  final String description;
  final int price;
  final int durationMinutes;
}

class TeamMember {
  const TeamMember({
    required this.id,
    required this.name,
    required this.role,
    required this.imageUrl,
    required this.rating,
  });

  final String id;
  final String name;
  final String role;
  final String imageUrl;
  final double rating;
}

class BusinessReview {
  const BusinessReview({
    required this.author,
    required this.rating,
    required this.comment,
    required this.dateLabel,
  });

  final String author;
  final double rating;
  final String comment;
  final String dateLabel;
}

class Business {
  const Business({
    required this.id,
    required this.name,
    required this.categoryLabel,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.distanceKm,
    required this.city,
    required this.quote,
    required this.about,
    required this.phone,
    required this.address,
    required this.isOpen,
    required this.openUntil,
    required this.hours,
    required this.amenities,
    required this.services,
    required this.team,
    required this.reviews,
  });

  final String id;
  final String name;
  final String categoryLabel;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final double distanceKm;
  final String city;
  final String quote;
  final String about;
  final String phone;
  final String address;
  final bool isOpen;
  final String openUntil;
  final String hours;
  final List<String> amenities;
  final List<BusinessService> services;
  final List<TeamMember> team;
  final List<BusinessReview> reviews;
}

class Booking {
  const Booking({
    required this.businessId,
    required this.businessName,
    required this.serviceNames,
    required this.staffName,
    required this.dateLabel,
    required this.timeLabel,
    required this.total,
  });

  final String businessId;
  final String businessName;
  final List<String> serviceNames;
  final String staffName;
  final String dateLabel;
  final String timeLabel;
  final int total;
}
