import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static final env = dotenv.get('APP_ENV', fallback: 'development');
  static final apiUrl = dotenv.get('BASE_URL', fallback: '');
  static final news_API_key = dotenv.get('NEWS_API_KEY', fallback: '');
}