import 'package:flutter/material.dart';

import '../../features/auth/login_screen.dart';
import '../../features/auth/register_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/video/video_list_screen.dart';
import '../../features/video/video_detail_screen.dart';
import '../../features/chat/video_chat_screen.dart';
import '../../features/reviews/reviews_screen.dart';
import '../../features/catalog/catalog_screen.dart';
import '../../features/cart/cart_screen.dart';
import '../../features/checkout/checkout_screen.dart';
import '../../features/orders/orders_screen.dart';
import '../../features/payments/payments_screen.dart';
import '../../features/deliveries/deliveries_screen.dart';
import '../../features/appointments/appointments_screen.dart';
import '../../features/vendor_panel/commerce/commerce_panel_screen.dart';
import '../../features/vendor_panel/commerce/vendor_deliveries_screen.dart';
import '../../features/vendor_panel/prestador/prestador_panel_screen.dart';
import '../deeplink/deep_link.dart';

class AppRouter {
  static Map<String, WidgetBuilder> routes = {
    '/': (context) => const HomeScreen(),
    '/login': (context) => const LoginScreen(),
    '/register': (context) => const RegisterScreen(),
    '/videos': (context) => const VideoListScreen(),
    '/video': (context) => const VideoDetailScreen(),
    '/chat': (context) => const VideoChatScreen(),
    '/reviews': (context) => const ReviewsScreen(),
    '/catalog': (context) => const CatalogScreen(),
    '/cart': (context) => const CartScreen(),
    '/checkout': (context) => const CheckoutScreen(),
    '/orders': (context) => const OrdersScreen(),
    '/payments': (context) => const PaymentsScreen(),
    '/deliveries': (context) => const DeliveriesScreen(),
    '/appointments': (context) => const AppointmentsScreen(),
    '/vendor/commerce': (context) => const CommercePanelScreen(),
    '/vendor/commerce/deliveries': (context) => const VendorDeliveriesScreen(),
    '/vendor/prestador': (context) => const PrestadorPanelScreen(),
  };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final builder = routes[settings.name];
    final name = settings.name;
    if (builder != null) {
      final args = settings.arguments;
      // Use deeplink arg for initial video if no explicit argument was passed
      final enrichedArgs = name == '/video' && args == null && DeepLink.initialArgs != null ? DeepLink.initialArgs : args;
      return MaterialPageRoute(builder: (ctx) => builder(ctx), settings: RouteSettings(name: settings.name, arguments: enrichedArgs));
    }
    return null;
  }
}
