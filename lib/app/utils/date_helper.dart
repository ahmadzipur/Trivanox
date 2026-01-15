class DateHelper {
  static String formatDMY(String date) {
    try {
      final parts = date.split('-');
      if (parts.length != 3) return date;
      return '${parts[2]}-${parts[1]}-${parts[0]}';
    } catch (_) {
      return date;
    }
  }

  static String formatDate(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    final y = date.year.toString();

    return '$d-$m-$y';
  }

  static String formatDateTime(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    final y = date.year.toString();

    final h = date.hour.toString().padLeft(2, '0');
    final min = date.minute.toString().padLeft(2, '0');
    final s = date.second.toString().padLeft(2, '0');

    return '$d-$m-$y $h:$min:$s';
  }
}
