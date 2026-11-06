import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Basic test setup', () {
    test('Simple calculation test', () {
      expect(1 + 1, 2);
    });

    test('String comparison test', () {
      expect('Flutter', 'Flutter');
    });

    test('List test', () {
      final items = ['Books', 'Movies', 'My Picks'];

      expect(items.length, 3);
      expect(items, contains('Books'));
    });
  });
}