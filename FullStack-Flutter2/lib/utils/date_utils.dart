import 'package:intl/intl.dart';

class DateUtils {
  static final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  static final DateFormat _timeFormat = DateFormat('HH:mm');
  static final DateFormat _dateTimeFormat = DateFormat('dd/MM/yyyy HH:mm');
  static final DateFormat _shortDateFormat = DateFormat('dd MMM');
  static final DateFormat _fullDateFormat = DateFormat('EEEE, dd MMMM yyyy');
  
  static String formatDate(DateTime date) {
    return _dateFormat.format(date);
  }
  
  static String formatTime(DateTime date) {
    return _timeFormat.format(date);
  }
  
  static String formatDateTime(DateTime date) {
    return _dateTimeFormat.format(date);
  }
  
  static String formatShortDate(DateTime date) {
    return _shortDateFormat.format(date);
  }
  
  static String formatFullDate(DateTime date) {
    return _fullDateFormat.format(date);
  }
  
  static String getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now);
    
    if (difference.inDays < 0) {
      return 'Pasado';
    } else if (difference.inDays == 0) {
      return 'Hoy';
    } else if (difference.inDays == 1) {
      return 'Mañana';
    } else if (difference.inDays < 7) {
      return 'En ${difference.inDays} días';
    } else {
      return formatShortDate(date);
    }
  }
  
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && 
           date.month == now.month && 
           date.day == now.day;
  }
  
  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year && 
           date.month == tomorrow.month && 
           date.day == tomorrow.day;
  }
}
