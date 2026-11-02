import 'package:bookly/features/business/data/models/business.dart';
import 'package:bookly/features/home/data/models/home_models.dart';

abstract final class BusinessCatalog {
  static Business? byId(String id) {
    final featured = _featured[id];
    if (featured != null) return featured;
    final place = HomeMockData.byId(id);
    if (place == null) return null;
    return _fromPlace(place);
  }

  static const _urbanTeam = [
    TeamMember(
      id: 'arjun',
      name: 'Arjun',
      role: 'Senior Barber',
      imageUrl:
          'https://images.unsplash.com/photo-1621605815971-fbc98d665033?auto=format&fit=crop&w=400&q=80',
      rating: 4.9,
    ),
    TeamMember(
      id: 'rahul',
      name: 'Rahul',
      role: 'Stylist',
      imageUrl:
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=400&q=80',
      rating: 4.8,
    ),
    TeamMember(
      id: 'vishnu',
      name: 'Vishnu',
      role: 'Master Groomer',
      imageUrl:
          'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=400&q=80',
      rating: 4.9,
    ),
    TeamMember(
      id: 'meera',
      name: 'Meera',
      role: 'Color Specialist',
      imageUrl:
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=400&q=80',
      rating: 4.7,
    ),
  ];

  static const Map<String, Business> _featured = {
    'urban-studio': Business(
      id: 'urban-studio',
      name: 'Urban Studio',
      categoryLabel: 'PREMIUM SALON & BARBER',
      imageUrl:
          'https://images.unsplash.com/photo-1585747860715-2ba37e788b70?auto=format&fit=crop&w=1400&q=80',
      rating: 4.9,
      reviewCount: 1284,
      distanceKm: 0.8,
      city: 'Kozhikode',
      quote: 'Premium grooming and styling in a modern, relaxed environment.',
      about:
          'Urban Studio is a premium salon and barber atelier in Kozhikode. Book cuts, beard work, and styling with specialists who keep slots visible in real time.',
      phone: '+919876543210',
      address: 'Mavoor Road, Kozhikode, Kerala 673001',
      isOpen: true,
      openUntil: '8:00 PM',
      hours: 'Mon–Sun · 10:00 AM – 8:00 PM',
      amenities: ['Parking', 'AC interiors', 'Card & UPI', 'Complimentary consult'],
      services: [
        BusinessService(
          id: 'haircut',
          name: 'Haircut',
          description: 'Precision scissor cut, wash, and tailored styling.',
          price: 299,
          durationMinutes: 30,
        ),
        BusinessService(
          id: 'haircut-beard',
          name: 'Haircut + Beard',
          description: 'Full head sculpt & razor-sharp beard grooming.',
          price: 499,
          durationMinutes: 45,
        ),
        BusinessService(
          id: 'premium-styling',
          name: 'Premium Styling',
          description: 'Complete hair spa treatment, cut, and blow dry.',
          price: 699,
          durationMinutes: 60,
        ),
      ],
      team: _urbanTeam,
      reviews: [
        BusinessReview(
          author: 'Nikhil',
          rating: 5,
          comment: 'Arjun nailed the fade. Clean shop, on-time slot, easy booking.',
          dateLabel: '2 days ago',
        ),
        BusinessReview(
          author: 'Sana',
          rating: 4.8,
          comment: 'Loved the styling. Staff explained products without hard selling.',
          dateLabel: '1 week ago',
        ),
        BusinessReview(
          author: 'Ravi',
          rating: 4.9,
          comment: 'Best barber chair in Kozhikode. Will rebook the haircut + beard combo.',
          dateLabel: '2 weeks ago',
        ),
      ],
    ),
  };

  static Business _fromPlace(PopularPlace place) {
    final services = _servicesFor(place);
    return Business(
      id: place.id,
      name: place.name,
      categoryLabel: place.category.toUpperCase(),
      imageUrl: place.imageUrl,
      rating: place.rating,
      reviewCount: 420,
      distanceKm: double.tryParse(place.distanceLabel.replaceAll(' km', '')) ?? 1.5,
      city: 'Kozhikode',
      quote: place.subtitle,
      about: '${place.name} in Kozhikode. ${place.subtitle}. Book a slot and pick a specialist.',
      phone: '+919812345678',
      address: 'Kozhikode, Kerala',
      isOpen: place.slotsOpen,
      openUntil: '8:00 PM',
      hours: 'Mon–Sun · 9:00 AM – 8:00 PM',
      amenities: const ['Wi-Fi', 'UPI', 'Waiting lounge'],
      services: services,
      team: const [
        TeamMember(
          id: 'lead',
          name: 'Anand',
          role: 'Lead specialist',
          imageUrl:
              'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&w=400&q=80',
          rating: 4.7,
        ),
        TeamMember(
          id: 'associate',
          name: 'Diya',
          role: 'Associate',
          imageUrl:
              'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&w=400&q=80',
          rating: 4.6,
        ),
        TeamMember(
          id: 'junior',
          name: 'Kiran',
          role: 'Junior specialist',
          imageUrl:
              'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=400&q=80',
          rating: 4.5,
        ),
      ],
      reviews: [
        BusinessReview(
          author: 'Amina',
          rating: place.rating,
          comment: 'Clean space and easy booking through Bookly.',
          dateLabel: '3 days ago',
        ),
        BusinessReview(
          author: 'Joseph',
          rating: 4.5,
          comment: 'Would book again. Staff was on time.',
          dateLabel: '1 week ago',
        ),
      ],
    );
  }

  static List<BusinessService> _servicesFor(PopularPlace place) {
    switch (place.category) {
      case 'Barber':
        return [
          BusinessService(
            id: 'fade',
            name: 'Signature Fade',
            description: place.subtitle,
            price: place.startingPrice,
            durationMinutes: 30,
          ),
          BusinessService(
            id: 'beard',
            name: 'Beard Sculpt',
            description: 'Hot towel, line-up, and beard oil finish.',
            price: place.startingPrice + 150,
            durationMinutes: 25,
          ),
          BusinessService(
            id: 'combo',
            name: 'Cut + Beard',
            description: 'Full grooming session with wash.',
            price: place.startingPrice + 250,
            durationMinutes: 50,
          ),
        ];
      case 'Spa':
        return [
          BusinessService(
            id: 'aroma',
            name: 'Aromatherapy',
            description: place.subtitle,
            price: place.startingPrice,
            durationMinutes: 60,
          ),
          BusinessService(
            id: 'steam',
            name: 'Steam Recovery',
            description: 'Guided steam and cool-down ritual.',
            price: place.startingPrice + 200,
            durationMinutes: 45,
          ),
          BusinessService(
            id: 'facial',
            name: 'Glow Facial',
            description: 'Deep cleanse, mask, and hydration.',
            price: place.startingPrice + 100,
            durationMinutes: 50,
          ),
        ];
      case 'Fitness':
        return [
          BusinessService(
            id: 'pt',
            name: 'Personal Training',
            description: place.subtitle,
            price: place.startingPrice,
            durationMinutes: 60,
          ),
          BusinessService(
            id: 'hiit',
            name: 'HIIT Session',
            description: 'Coach-led interval workout.',
            price: place.startingPrice - 50,
            durationMinutes: 45,
          ),
          BusinessService(
            id: 'assess',
            name: 'Fitness Assessment',
            description: 'Form check, goals, and plan.',
            price: 299,
            durationMinutes: 30,
          ),
        ];
      case 'Clinic':
        return [
          BusinessService(
            id: 'consult',
            name: 'General Consult',
            description: place.subtitle,
            price: place.startingPrice,
            durationMinutes: 20,
          ),
          BusinessService(
            id: 'dental',
            name: 'Dental Check-up',
            description: 'Exam and hygiene advice.',
            price: place.startingPrice + 150,
            durationMinutes: 30,
          ),
          BusinessService(
            id: 'labs',
            name: 'Basic Diagnostics',
            description: 'On-site vitals and reports.',
            price: 499,
            durationMinutes: 25,
          ),
        ];
      default:
        return [
          BusinessService(
            id: 'cut',
            name: 'Haircut',
            description: 'Precision cut, wash, and finish.',
            price: place.startingPrice,
            durationMinutes: 30,
          ),
          BusinessService(
            id: 'color',
            name: 'Hair Color',
            description: 'Consultation, color, and blow dry.',
            price: place.startingPrice + 400,
            durationMinutes: 90,
          ),
          BusinessService(
            id: 'spa-hair',
            name: 'Hair Spa',
            description: 'Nourish, steam, and style.',
            price: place.startingPrice + 200,
            durationMinutes: 60,
          ),
        ];
    }
  }
}
