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
import '../../features/vendor_panel/prestador/prestador_panel_screen.dart';

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
    '/vendor/prestador': (context) => const PrestadorPanelScreen(),
  };
}
