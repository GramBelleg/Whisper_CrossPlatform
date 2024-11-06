import 'package:test/test.dart';
import 'package:whisper/validators/form-validation/longest-repeated-letter.dart';

void main() {
  group('Longest Repeated Letter', () {
    test('valid name', () {
      expect(
        LongestRepeatedLetter("Seif Mohamed"),
        '',
      );
    });

    test('valid name', () {
      expect(
        LongestRepeatedLetter("Muhammed"),
        '',
      );
    });

    test('invalid name', () {
      expect(
        LongestRepeatedLetter("Muhammmed"),
        'mmm',
      );
    });

    test('valid name', () {
      expect(
        LongestRepeatedLetter("Sophia Aaron"),
        '',
      );
    });

    test('invalid name', () {
      expect(
        LongestRepeatedLetter("Sophia Aaaron"),
        'aaa',
      );
    });

    test('invalid name', () {
      expect(
        LongestRepeatedLetter("SophiaAaron"),
        'aaa',
      );
    });
  });
}
