import 'package:test/test.dart';
import 'package:whisper/validators/form-validation/longest_repteated_letter.dart';

void main() {
  group('Longest Repeated Letter', () {
    test('valid name', () {
      expect(
        longestRepeatedLetter("Seif Mohamed"),
        '',
      );
    });

    test('valid name', () {
      expect(
        longestRepeatedLetter("Muhammed"),
        '',
      );
    });

    test('invalid name', () {
      expect(
        longestRepeatedLetter("Muhammmed"),
        'mmm',
      );
    });

    test('valid name', () {
      expect(
        longestRepeatedLetter("Sophia Aaron"),
        '',
      );
    });

    test('invalid name', () {
      expect(
        longestRepeatedLetter("Sophia Aaaron"),
        'aaa',
      );
    });

    test('invalid name', () {
      expect(
        longestRepeatedLetter("SophiaAaron"),
        'aaa',
      );
    });
  });
}
