import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class UrlHelper {
  /// Opens a URL safely - uses JavaScript window.open on web for reliability
  static Future<void> openUrl(String url) async {
    try {
      if (kIsWeb) {
        // On web, use JavaScript directly for reliability
        html.window.open(url, '_blank');
      } else {
        // On mobile/desktop, use url_launcher
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      }
    } catch (e) {
      debugPrint('Error opening URL: $e');
      // Fallback: try url_launcher
      try {
        await launchUrl(Uri.parse(url));
      } catch (_) {
        debugPrint('Fallback also failed');
      }
    }
  }

  /// Opens LinkedIn profile
  static Future<void> openLinkedIn(String linkedInId) async {
    final url = 'https://www.linkedin.com/in/$linkedInId';
    await openUrl(url);
  }
}
