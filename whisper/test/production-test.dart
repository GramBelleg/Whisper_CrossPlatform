import 'validate-email-test.dart' as validate_email_test;
import 'validate-name-test.dart' as validate_name_test;
import 'validate-password-test.dart' as validate_password_test;
import 'validate-name-with-api-test.dart' as validate_name_with_api_test;
import 'validate-phoneNumber-test.dart' as validate_phoneNumber_test;
import 'longest-repeated-letter-test.dart' as longest_repeated_letter_test;

void main() {
  validate_email_test.main();
  validate_name_test.main();
  validate_name_with_api_test.main();
  validate_password_test.main();
  validate_phoneNumber_test.main();
  longest_repeated_letter_test.main();
}
