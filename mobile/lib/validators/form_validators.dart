String? emailValidator(String value) {
  if (value.isEmpty) return 'Enter your email.';

  const pattern =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";

  final regex = RegExp(pattern);

  return !regex.hasMatch(value) ? 'Enter a valid email address.' : null;
}

String? passwordValidator(String value) {
  if (value.isEmpty) return 'Enter your password.';

  if (value.length < 8 || value.length > 255) {
    return 'Password must be between 8 and 255 characters.';
  }

  return null;
}

String? nameValidator(String value) {
  if (value.isEmpty) return 'Enter your name.';

  if (value.length < 3 || value.length > 20) {
    return 'Name must be between 3 and 20 characters.';
  }

  return null;
}

String? confirmPasswordValidator(String value, String password) {
  if (value.isEmpty) return 'Confirm your password.';

  if (value != password) {
    return 'Passwords do not match.';
  }

  return null;
}
