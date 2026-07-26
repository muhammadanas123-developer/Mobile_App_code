

/// Centralized API configuration and endpoints constants for FastAPI backend
class ApiConstants {
  // Override host IP here if testing on a physical mobile device (e.g., 'http://192.168.1.50:8000/api')
  static const String customBaseUrl = '';

  static String get baseUrl {
    if (customBaseUrl.isNotEmpty) {
      return customBaseUrl;
    }
    // Production Render API URL
    return 'https://fyp-utti.onrender.com/api';
  }

  // Auth Endpoints
  static const String login = '/auth/login';
  static const String signup = '/auth/signup';
  static const String profile = '/auth/profile';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';

  // Salons & Services Endpoints
  static const String salons = '/salons';
  static const String ownerSalons = '/salons/owner/my';
  static String salonDetails(String id) => '/salons/$id';
  static String salonSlots(String id) => '/salons/$id/slots';
  static const String services = '/services';
  static String salonServices(String salonId) => '/services/salon/$salonId';

  // Appointments Endpoints
  static const String appointments = '/appointments';
  static String appointmentStatus(String id) => '/appointments/$id/status';
  static String appointmentReschedule(String id) => '/appointments/$id/reschedule';

  // Favorites Endpoints
  static const String favorites = '/favorites';
  static String favoriteSalon(String salonId) => '/favorites/$salonId';

  // Reviews Endpoints
  static const String reviews = '/reviews';
  static String salonReviews(String salonId) => '/reviews/salon/$salonId';

  // AI Endpoints
  static const String aiChat = '/ai/chat';
  static const String aiSkinAnalysis = '/ai/skin-analysis';
  static const String aiHairAnalysis = '/ai/hair-analysis';
  static const String aiFaceAnalysis = '/ai/analyze-face';
  static const String aiRecommendSalon = '/ai/recommend-salon';
  static const String aiRecommendService = '/ai/recommend-service';
}
