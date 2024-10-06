class Settings {
  final int id;
  final String theme;
  final String language;

  const Settings({
    required this.id,
    required this.theme,
    required this.language,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'theme': theme,
      'language': language,
    };
  }

  @override
  String toString() {
    return 'Setting(id: $id, theme: $theme, language: $language)';
  }

  factory Settings.fromMap(Map<String, dynamic> map) {
    return Settings(
      id: map['id'],
      theme: map['theme'],
      language: map['language'],
    );
  }
}
