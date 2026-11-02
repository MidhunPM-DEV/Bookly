import 'package:bookly/core/theme/app_colors.dart';
import 'package:bookly/features/business/data/business_catalog.dart';
import 'package:bookly/features/business/data/models/business.dart';
import 'package:bookly/features/business/presentation/widgets/booking_sheet.dart';
import 'package:bookly/features/favorites/favorites_store.dart';
import 'package:bookly/features/home/presentation/widgets/remote_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

part 'business_details_components.dart';
part 'business_details_booking.dart';

class BusinessDetailsPage extends StatefulWidget {
  const BusinessDetailsPage({super.key, required this.businessId});

  final String businessId;

  @override
  State<BusinessDetailsPage> createState() => _BusinessDetailsPageState();
}

class _BusinessDetailsPageState extends State<BusinessDetailsPage> {
  int _tab = 1;
  final Set<String> _selectedServiceIds = {};
  String? _selectedStaffId;

  @override
  void initState() {
    super.initState();
    final business = BusinessCatalog.byId(widget.businessId);
    if (business != null && business.services.isNotEmpty) {
      _selectedServiceIds.add(business.services.first.id);
    }
  }

  Future<void> _launch(Uri uri) async {
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open this action'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final business = BusinessCatalog.byId(widget.businessId);
    if (business == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(title: const Text('Business Details')),
        body: const Center(child: Text('Shop not found')),
      );
    }

    final selectedServices = business.services
        .where((s) => _selectedServiceIds.contains(s.id))
        .toList();
    final total = selectedServices.fold(
      0,
      (sum, service) => sum + service.price,
    );
    TeamMember? selectedStaff;
    for (final member in business.team) {
      if (member.id == _selectedStaffId) {
        selectedStaff = member;
        break;
      }
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _DetailsHeader(onBack: () => context.pop()),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(overscroll: false),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  children: [
                    _HeroImage(
                      business: business,
                      favorite: FavoritesStore.instance.contains(business.id),
                      onFavorite: () =>
                          FavoritesStore.instance.toggle(business.id),
                      onShare: () => _share(business),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      business.categoryLabel,
                      style: const TextStyle(
                        color: AppColors.accentGreen,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            business.name,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              height: 1.1,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.star_rounded,
                          color: Color(0xFFF5C518),
                          size: 22,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${business.rating}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '(${NumberFormat('#,###').format(business.reviewCount)} reviews)  •  ${business.distanceKm} km  •  ${business.city}',
                      style: const TextStyle(
                        color: AppColors.mutedDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1EEEA),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        '“${business.quote}”',
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w600,
                          color: AppColors.mutedDark,
                          height: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _ActionButton(
                          icon: Icons.call_outlined,
                          label: 'Call',
                          onTap: () =>
                              _launch(Uri(scheme: 'tel', path: business.phone)),
                        ),
                        _ActionButton(
                          icon: Icons.near_me_outlined,
                          label: 'Directions',
                          onTap: () => _launch(
                            Uri.parse(
                              'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(business.address)}',
                            ),
                          ),
                        ),
                        _ActionButton(
                          icon: Icons.ios_share_rounded,
                          label: 'Share',
                          onTap: () => _share(business),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    _DetailsTabs(
                      index: _tab,
                      onChanged: (index) => setState(() => _tab = index),
                    ),
                    const SizedBox(height: 18),
                    if (_tab == 0) _OverviewTab(business: business),
                    if (_tab == 1)
                      _ServicesTab(
                        business: business,
                        selectedIds: _selectedServiceIds,
                        selectedStaffId: _selectedStaffId,
                        onToggleService: (id) {
                          setState(() {
                            if (_selectedServiceIds.contains(id)) {
                              _selectedServiceIds.remove(id);
                            } else {
                              _selectedServiceIds.add(id);
                            }
                          });
                        },
                        onSelectStaff: (id) => setState(
                          () => _selectedStaffId = id == _selectedStaffId
                              ? null
                              : id,
                        ),
                      ),
                    if (_tab == 2) _ReviewsTab(business: business),
                  ],
                ),
              ),
            ),
            _BookingBar(
              count: selectedServices.length,
              total: total,
              onBook: selectedServices.isEmpty
                  ? () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Select at least one service'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  : () => showBookingSheet(
                      context,
                      business: business,
                      services: selectedServices,
                      staff: selectedStaff,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _share(Business business) {
    return Share.share(
      '${business.name} · ${business.city}\n${business.address}\nBook on Bookly.',
      subject: business.name,
    );
  }
}
