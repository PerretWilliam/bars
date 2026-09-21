import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lyrics/providers/notepad_provider.dart';

void main() {
  test('defaults to visible and toggles', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(timecodeVisibleProvider), isTrue);

    container.read(timecodeVisibleProvider.notifier).toggle();
    expect(container.read(timecodeVisibleProvider), isFalse);

    container.read(timecodeVisibleProvider.notifier).toggle();
    expect(container.read(timecodeVisibleProvider), isTrue);
  });
}
