String? nameValidator(String value) {
  if (value.isEmpty) return 'Name is required.';

  if (value.length < 3 || value.length > 20) {
    return 'Name must be between 3 and 20 characters.';
  }

  return null;
}

String? emailValidator(String value) {
  if (value.isEmpty) return 'Email is required.';

  const pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  final regex = RegExp(pattern);

  return !regex.hasMatch(value) ? 'Enter a valid email address.' : null;
}

String? passwordValidator(String value) {
  if (value.isEmpty) return 'Password is required.';

  if (value.length < 8 || value.length > 255) {
    return 'Password must be between 8 and 255 characters.';
  }

  return null;
}

String? confirmPasswordValidator(String value, String password) {
  if (value != password || value.isEmpty) {
    return 'Passwords do not match.';
  }

  return null;
}
