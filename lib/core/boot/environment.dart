import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  String apiKey = '';
  String appId = '';
  String messagingSenderId = '';
  String projectId = '';

  static Environment _instance = Environment._internal();

  static Environment get instance => _instance;

  Environment._internal({
    this.apiKey = '',
    this.appId = '',
    this.messagingSenderId = '',
    this.projectId = '',
  });

  static Future<void> initialize({String filename = '.env'}) async {
    await dotenv.load(fileName: filename);
    final apiKey = _getString('API_KEY');
    final appId = _getString('APP_ID');
    final messagingSenderId = _getString('MESSAGING_SENDER_ID');
    final projectId = _getString('PROJECT_ID');

    _instance = Environment._internal(
        apiKey: apiKey,
        appId: appId,
        messagingSenderId: messagingSenderId,
        projectId: projectId);
  }

  static String _getString(String key) {
    if (!dotenv.env.containsKey(key)) {
      return '';
    }

    return dotenv.env[key] as String;
  }
}
