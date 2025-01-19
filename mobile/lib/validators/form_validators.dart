String? nameValidator(String value, String errorEmtpy, String errorLength) {
  if (value.isEmpty) return errorEmtpy;

  if (value.length < 3 || value.length > 20) {
    return errorLength;
  }

  return null;
}

String? emailValidator(String value, String errorEmtpy, String errorInvalid) {
  if (value.isEmpty) return errorEmtpy;

  const pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  final regex = RegExp(pattern);

  return !regex.hasMatch(value) ? errorInvalid : null;
}

String? passwordValidator(
    String value, String errorRequired, String errorLength) {
  if (value.isEmpty) return errorRequired;

  if (value.length < 8 || value.length > 255) {
    return errorLength;
  }

  return null;
}

String? confirmPasswordValidator(
    String value, String password, String errorMatch) {
  if (value != password || value.isEmpty) {
    return errorMatch;
  }

  return null;
}

String? validateCode(String codeVerification, String value, String errorEmpty,
    String errorLength) {
  if (value.isEmpty) return errorEmpty;

  if (value != codeVerification) {
    return errorLength;
  }

  return null;
}
