class ServiceDay {
  static DateTime start(DateTime date, int hour) => DateTime(
    date.year,
    date.month,
    date.day - (date.hour < hour ? 1 : 0),
    hour,
  );

  // Un jour civil peut durer 23 ou 25 heures au changement d'heure.
  static DateTime next(DateTime start) =>
      DateTime(start.year, start.month, start.day + 1, start.hour);
}
