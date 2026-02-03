import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Local Storage Tests', () {
    setUp(() async {
      // Clear all preferences before each test
      SharedPreferences.setMockInitialValues({});
      await SharedPreferences.getInstance();
    });

    test('should store and retrieve access token', () async {
      final prefs = await SharedPreferences.getInstance();

      // Store access token
      await prefs.setString('accessToken', 'test_access_token_123');

      // Retrieve access token
      final storedToken = prefs.getString('accessToken');

      expect(storedToken, 'test_access_token_123');
    });

    test('should store and retrieve refresh token', () async {
      final prefs = await SharedPreferences.getInstance();

      // Store refresh token
      await prefs.setString('refreshToken', 'test_refresh_token_456');

      // Retrieve refresh token
      final storedToken = prefs.getString('refreshToken');

      expect(storedToken, 'test_refresh_token_456');
    });

    test('should store and retrieve user data as JSON', () async {
      final prefs = await SharedPreferences.getInstance();

      // Sample user data as JSON string
      const userDataJson = '{"id": "123", "name": "John Doe", "email": "john@example.com"}';

      // Store user data
      await prefs.setString('userData', userDataJson);

      // Retrieve user data
      final storedData = prefs.getString('userData');

      expect(storedData, userDataJson);
    });

    test('should remove tokens and user data during logout simulation', () async {
      final prefs = await SharedPreferences.getInstance();

      // Pre-populate with data
      await prefs.setString('accessToken', 'test_access_token');
      await prefs.setString('refreshToken', 'test_refresh_token');
      await prefs.setString('userData', '{"id": "123", "name": "Test User"}');

      // Verify data is stored
      expect(prefs.getString('accessToken'), 'test_access_token');
      expect(prefs.getString('refreshToken'), 'test_refresh_token');
      expect(prefs.getString('userData'), '{"id": "123", "name": "Test User"}');

      // Simulate logout by removing data
      await prefs.remove('accessToken');
      await prefs.remove('refreshToken');
      await prefs.remove('userData');

      // Verify data is cleared
      expect(prefs.getString('accessToken'), isNull);
      expect(prefs.getString('refreshToken'), isNull);
      expect(prefs.getString('userData'), isNull);
    });
  });
}