abstract final class DateFormatter {
  static const List<String> _months = [
    'jan',
    'fev',
    'mar',
    'abr',
    'mai',
    'jun',
    'jul',
    'ago',
    'set',
    'out',
    'nov',
    'dez',
  ];

  static String compact(DateTime date) {
    return '${date.day} ${_months[date.month - 1]} ${date.year}';
  }

  static String monthYear(DateTime date) {
    return '${_months[date.month - 1]} ${date.year}';
  }
}
