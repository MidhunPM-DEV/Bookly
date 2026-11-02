import 'package:bookly/features/business/data/models/business.dart';
import 'package:flutter/foundation.dart';

class BookingStore extends ChangeNotifier {
  BookingStore._();

  static final BookingStore instance = BookingStore._();

  final List<Booking> _bookings = [];

  List<Booking> get bookings => List.unmodifiable(_bookings);

  void add(Booking booking) {
    _bookings.insert(0, booking);
    notifyListeners();
  }
}
