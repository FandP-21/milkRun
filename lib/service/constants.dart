import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';

class Constants {
  // app name
  static String appName = 'Grocery Pro';

  // delopy url production
  static String apiUrl = DotEnv().env['API_URL'];

  static String baseUrl = 'https://$API_KEY:$API_PASSWORD@$STORE_NAME.myshopify.com/admin/api/$API_VERSION';
//api end points
  static String GET_ALL_PRODUCTS = "/products";//List all products

//auth keys
  static String API_KEY = "cd5845fe0a28f4a78b0e0158621ec405";
  static String API_PASSWORD = "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";
  static String STORE_NAME = "milkrun-rabbit";
  static String API_VERSION = "2021-04";


  // ONE_SIGNAL_KEY
  static String oneSignalKey = DotEnv().env['ONE_SIGNAL_KEY'];

  // googleapikey
  static String googleMapApiKey = Platform.isIOS
      ? DotEnv().env['IOS_GOOGLE_MAP_API_KEY']
      : DotEnv().env['ANDROID_GOOGLE_MAP_API_KEY'];

  // stripe key
  static String stripKey = DotEnv().env['STRIPE_KEY'];

  // image url
  static String imageUrlPath = DotEnv().env['IMAGE_URL_PATH'];

  // PREDEFINED
  static String predefined = DotEnv().env['PREDEFINED'] ?? "false";
}
