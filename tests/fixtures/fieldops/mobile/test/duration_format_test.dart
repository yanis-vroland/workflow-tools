import 'package:fieldops_companion/utils/duration_format.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('formatDuration', () {
    test('affiche les minutes seules sous une heure', () {
      expect(formatDuration(const Duration(minutes: 45)), '45 min');
    });

    test('affiche les heures et les minutes', () {
      expect(formatDuration(const Duration(hours: 2, minutes: 5)), '2 h 05');
    });
  });
}
