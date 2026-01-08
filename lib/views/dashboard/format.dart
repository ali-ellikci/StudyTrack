String formatMinutes(double totalMinutes) {
  final hours = totalMinutes ~/ 60;
  final minutes = totalMinutes % 60;
  return '$hours:${minutes.toInt().toString().padLeft(2, '0')}';
}
