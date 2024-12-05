
// Code is from:
// https://stackoverflow.com/a/60528001
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}