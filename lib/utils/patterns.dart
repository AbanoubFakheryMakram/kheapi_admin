class MyPatterns {
  static String _emailPatterns =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
  static RegExp _emailRegularExpression = RegExp(_emailPatterns);

  static String _identityNumberPattern =
      r'(2|3)[0-9][1-9][0-1][1-9][0-3][1-9](01|02|03|04|11|12|13|14|15|16|17|18|19|21|22|23|24|25|26|27|28|29|31|32|33|34|35|88)\d\d\d\d\d';
  static RegExp _identityRegularExpression = RegExp(_identityNumberPattern);

  static String _phoneNumberPattern = r'^(01)[0-9]{8}';
  static RegExp _phoneNumberRegularExpression = RegExp(_phoneNumberPattern);

  static bool isEmailValid(String input) {
    return _emailRegularExpression.hasMatch(input);
  }

  static bool isIdentityNumberValid(String input) {
    return _identityRegularExpression.hasMatch(input);
  }

  static bool isPhoneValid(String input) {
    return _phoneNumberRegularExpression.hasMatch(input);
  }
}
