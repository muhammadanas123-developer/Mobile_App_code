import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'go_router_refresh_stream.dart';
import 'routes.dart';
import '../../features/authentication/presentation/splash_screen.dart';
import '../../features/authentication/presentation/auth_state_provider.dart';
import '../../features/customer/customer_shell.dart';
import '../../features/customer/home_tab.dart';
import '../../features/customer/search_results_screen.dart';
import '../../features/customer/wallet_screen.dart';
import '../../features/customer/notifications_screen.dart';
import '../../features/ai/ai_hub_tab.dart';
import '../../features/ai/ai_scan_flow_screen.dart';
import '../../features/ai/ai_chat_screen.dart';
import '../../features/booking/customer_bookings_tab.dart';
import '../../features/profile/profile_tab.dart';
import '../../features/profile/edit_profile_screen.dart';
import '../../features/profile/favorites_screen.dart';
import '../../features/profile/static_text_screen.dart';
import '../../features/booking/salon_detail_screen.dart';
import '../../features/booking/booking_flow_screen.dart';
import '../../features/salon_owner/owner_shell.dart';
import '../../features/salon_owner/owner_dashboard_tab.dart';
import '../../features/salon_owner/owner_calendar_tab.dart';
import '../../features/salon_owner/owner_bookings_tab.dart';
import '../../features/salon_owner/owner_reviews_tab.dart';
import '../../features/salon_owner/owner_revenue_screen.dart';
import '../../features/authentication/presentation/auth_screen.dart';
import '../../features/ai/ai_hub_tab.dart';
import '../../features/ai/ai_scan_flow_screen.dart';
import '../../features/ai/ai_chat_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

/// Provider that exposes the centralized GoRouter configuration.
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,

    initialLocation: Routes.splash,

    refreshListenable: GoRouterRefreshStream(
      ref.watch(authStateProvider.notifier).stream,
    ),

    redirect: (context, state) {
      final auth = ref.read(authStateProvider);

      if (auth.isLoading) {
        return Routes.splash;
      }

      final isAuth = state.matchedLocation == Routes.auth;
      final isSplash = state.matchedLocation == Routes.splash;

      if (!auth.isAuthenticated) {
        return isAuth ? null : Routes.auth;
      }

      if (isAuth || isSplash) {
        return auth.role == 'owner'
            ? Routes.ownerDashboard
            : Routes.customerHome;
      }

      return null;
    },

    routes: [
      GoRoute(
        path: Routes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: Routes.auth,
        builder: (context, state) => const AuthScreen(),
      ),

      // Customer Area nested shell navigation
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return CustomerShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.customerHome,
                builder: (context, state) => const HomeTab(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.customerAIHub,
                builder: (context, state) => const AIHubTab(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.customerBookings,
                builder: (context, state) => const CustomerBookingsTab(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.customerProfile,
                builder: (context, state) => const ProfileTab(isOwnerView: false),
              ),
            ],
          ),
        ],
      ),

      // Customer details sub-routes (outside bottom nav)
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '${Routes.salonDetail}/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '1';
          return SalonDetailScreen(salonId: id);
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: Routes.bookingFlow,
        builder: (context, state) {
          return const BookingFlowScreen();
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: Routes.searchResults,
        builder: (context, state) {
          return const SearchResultsScreen();
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: Routes.aiScan,
        builder: (context, state) {
          final type = state.uri.queryParameters['type'] ?? 'skin';
          return AIScanFlowScreen(scanType: type);
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: Routes.aiChat,
        builder: (context, state) {
          return const AIChatScreen();
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: Routes.wallet,
        builder: (context, state) {
          return const WalletScreen();
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: Routes.notifications,
        builder: (context, state) {
          return const NotificationsScreen();
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: Routes.editProfile,
        builder: (context, state) {
          return const EditProfileScreen();
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: Routes.favorites,
        builder: (context, state) {
          return const FavoritesScreen();
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: Routes.staticPage,
        builder: (context, state) {
          final title = state.uri.queryParameters['title'] ?? 'Info';
          final type = state.uri.queryParameters['type'] ?? 'help';
          return StaticTextScreen(title: title, type: type);
        },
      ),

      // Owner details sub-routes (outside bottom nav)
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: Routes.ownerReviews,
        builder: (context, state) {
          return const OwnerReviewsTab();
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: Routes.ownerRevenue,
        builder: (context, state) {
          return const OwnerRevenueScreen();
        },
      ),

      // Salon Owner Area nested shell navigation
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return OwnerShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.ownerDashboard,
                builder: (context, state) => const OwnerDashboardTab(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.ownerCalendar,
                builder: (context, state) => const OwnerCalendarTab(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.ownerBookings,
                builder: (context, state) => const OwnerBookingsTab(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.ownerProfile,
                builder: (context, state) => const ProfileTab(isOwnerView: true),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});