import 'package:flutter_test/flutter_test.dart';
import 'package:seera/core/services/validator.dart';

void main() {
  group('Validator Tests', () {
    test('isValidName should return true for valid names', () {
      expect(Validator.isValidName('Ahmed Mohamed'), isTrue);
      expect(Validator.isValidName('أحمد محمد'), isTrue);
    });

    test('isValidName should return false for names with numbers', () {
      expect(Validator.isValidName('Ahmed 123'), isFalse);
    });

    test('isValidEmail should validate standard emails', () {
      expect(Validator.isValidEmail('test@example.com'), isTrue);
      expect(Validator.isValidEmail('test.name@domain.co.uk'), isTrue);
      expect(Validator.isValidEmail('invalid-email'), isFalse);
    });

    test('isValidPhone should validate phone numbers', () {
      expect(Validator.isValidPhone('+20123456789'), isTrue);
      expect(Validator.isValidPhone('0123456789'), isTrue);
      expect(Validator.isValidPhone('abcd'), isFalse);
    });

    test('isValidUrl should validate standard URLs', () {
      expect(Validator.isValidUrl('https://google.com'), isTrue);
      expect(Validator.isValidUrl('not-a-url'), isFalse);
    });
  });
}
