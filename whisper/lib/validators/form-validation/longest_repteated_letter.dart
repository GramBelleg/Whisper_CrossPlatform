String longestRepeatedLetter(String name) {
  int maxCount = 1;
  int currentCount = 1;
  String maxChar = '';
  name = name.toLowerCase();
  for (int i = 1; i < name.length; i++) {
    if (name[i] == name[i - 1]) {
      currentCount++;
    } else {
      currentCount = 1;
    }

    if (currentCount > maxCount) {
      maxCount = currentCount;
      maxChar = name[i];
    }
  }

  return maxCount > 2 ? maxChar * maxCount : '';
}
