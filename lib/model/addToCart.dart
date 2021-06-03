import 'package:groceryPro/service/cart-service.dart';
import 'package:groceryPro/service/sentry-service.dart';

SentryError sentryError = new SentryError();

class AddToCart {
  static Future<Map<String, dynamic>> addAndUpdateProductMethod(
      buyNowProduct) async {
    final response = await CartService.addAndUpdateProduct(buyNowProduct);
    return response;
  }
}
