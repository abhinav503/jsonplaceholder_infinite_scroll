mixin UtilsMixin {
  String capitalizeFirst(String text) {
    return text.isNotEmpty
        ? '${text[0].toUpperCase()}${text.substring(1)}'
        : text;
  }
}
