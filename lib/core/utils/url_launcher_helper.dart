import 'package:url_launcher/url_launcher.dart';

abstract final class UrlLauncherHelper {
  static Future<void> open(String value) async {
    final uri = Uri.parse(value);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  static Future<void> call(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    await launchUrl(uri);
  }

  static Future<void> email(String email) async {
    final uri = Uri(scheme: 'mailto', path: email);
    await launchUrl(uri);
  }

  static Future<void> whatsapp(String number) async {
    final uri = Uri.parse('https://wa.me/55$number');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
