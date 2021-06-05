import 'package:sentry/sentry.dart';
/*
 SentryOptions options;
 SentryClient sentry = new SentryClient(options);*/

//"https://61bcefa6518f4429b7a7c0121519d231@sentry.io/1800138"
class SentryError {
  Future<Null> reportError(dynamic error, dynamic stackTrace) async {
    // print('Caught error: $error');
    // final SentryResponse response = await sentry.captureException(
    //   exception: error,
    //   stackTrace: stackTrace,
    // );
    // if (response.isSuccessful) {
    //   print('Success! Event ID: ${response.eventId}');
    // } else {
    //   print('Failed to report to Sentry.io: ${response.error}');
    // }
  }
}
