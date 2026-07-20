/// Routes contains constants paths for all app screens.
class Routes {
  Routes._();

  static const String splash = '/';
  static const String auth = '/auth';

  // Customer Shell Tab Routes
  static const String customerHome = '/customer/home';
  static const String customerAIHub = '/customer/ai-hub';
  static const String customerBookings = '/customer/bookings';
  static const String customerProfile = '/customer/profile';

  // Customer Detail Routes
  static const String salonDetail = '/customer/salon'; // will append '/:id'
  static const String bookingFlow = '/customer/booking-flow';
  static const String searchResults = '/customer/search';
  static const String aiScan = '/customer/ai-hub/scan';
  static const String aiChat = '/customer/ai-hub/chat';
  static const String wallet = '/customer/wallet';
  static const String notifications = '/customer/notifications';
  static const String editProfile = '/customer/profile/edit';
  static const String favorites = '/customer/profile/favorites';
  static const String staticPage = '/customer/profile/page';

  // Salon Owner Shell Tab Routes
  static const String ownerDashboard = '/owner/dashboard';
  static const String ownerCalendar = '/owner/calendar';
  static const String ownerBookings = '/owner/bookings';
  static const String ownerProfile = '/owner/profile';
  static const String ownerReviews = '/owner/reviews';
  static const String ownerRevenue = '/owner/revenue';
}