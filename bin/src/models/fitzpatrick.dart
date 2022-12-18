enum Fitzpatrick {
  light,
  mediumLight,
  medium,
  mediumDark,
  dark;

  @override
  String toString() => 'tone${index + 1}';
}