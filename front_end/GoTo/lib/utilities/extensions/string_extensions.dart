extension StringExtension on String {
  bool phoneNumberValidate() {
    return 10 <= length && length <= 12;
  }

  bool passwordValidate() {
    return RegExp(
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
    ).hasMatch(this);
  }

  bool confirmPasswordValidate(String password) {
    return compareTo(password) == 0;
  }

  int toInt() {
    return int.parse(this);
  }

  double toDouble() {
    return double.parse(this);
  }
}