extension StringExtensions on String {
  String getEmailPrefix() {
    final atIndex = indexOf('@');
    if (atIndex == -1) return this;
    return substring(0, atIndex);
  }
}
