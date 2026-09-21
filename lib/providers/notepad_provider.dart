import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimecodeVisibleNotifier extends Notifier<bool> {
  @override
  bool build() => true;

  void toggle() => state = !state;
}

final timecodeVisibleProvider = NotifierProvider<TimecodeVisibleNotifier, bool>(
  TimecodeVisibleNotifier.new,
);
