import '../test-common-functions.dart';

// Define different groups for login using a Map
final Map<String, List<String>> loginTestCases = {
  'Invalid Emails': [
    'invalidate',
    '@domain.com',
    'test@.com',
    'test@domain',
    'test@domain..com',
    'user@domain.com.', // Trailing dot
    '.user@domain.com', // Leading dot
    'user@domain.c', // Single character TLD
    'user@.com', // Missing local part
    'user@domain.com@domain.com', // Multiple '@'
    'user@domain..com', // Invalid consecutive dots
    '${generateLargeString(100)}@domain.com', // Excessively long local part
  ],
  'Invalid Passwords': [
    'password', // Missing uppercase, digit, special character
    'PASSWORD', // Missing lowercase, digit, special character
    'Password', // Missing digit and special character
    'Password1', // Missing special character
    'P@ssword', // Missing digit
    'pass@1234', // Missing uppercase
    'PASS@1234', // Missing lowercase
    '123456!', // Only digits and special character
    'aaaaaa@', // Only lowercase and special character
    'AAAAAA1!', // Only uppercase, digit, and special character
    'abcdefgh', // Only lowercase
    'abcdefg@', // Lowercase and special character only
    'ABCDEFG@', // Uppercase and special character only
    '123456@', // Digits and special character only
    'Ab1!', // Too short but valid structure
    'kKa1_@ahsh', // Invalid special character
    'Whi@perrrr123', // repeated characters
    '${generateLargeString(100)}@A1a', // Excessively long local part
  ],
  'Valid but Not Existing Emails': [
    'test@domain.com',
    'test@domain.corporate',
    'test@sub.domain.com',
    'test@domain.corporate',
    'test+education@domain.corporate',
    'karim.agami.ext@org.com',
  ],
};

