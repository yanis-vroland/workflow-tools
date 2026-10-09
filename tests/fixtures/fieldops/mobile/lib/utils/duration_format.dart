/// Formatage des durées d'intervention pour l'affichage.
String formatDuration(Duration duration) {
  if (duration.isNegative) {
    return '—';
  }
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  if (hours == 0) {
    return '$minutes min';
  }
  return minutes == 0 ? '$hours h' : '$hours h ${minutes.toString().padLeft(2, '0')}';
}
