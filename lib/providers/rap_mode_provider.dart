import 'package:flutter_riverpod/flutter_riverpod.dart';

enum RapModeSubMode { auto, static_ }

class RapModeSubModeNotifier extends Notifier<RapModeSubMode> {
  @override
  RapModeSubMode build() => RapModeSubMode.auto;

  void toggle() {
    state = state == RapModeSubMode.auto
        ? RapModeSubMode.static_
        : RapModeSubMode.auto;
  }
}

final rapModeSubModeProvider =
    NotifierProvider<RapModeSubModeNotifier, RapModeSubMode>(
      RapModeSubModeNotifier.new,
    );

const _minFontSize = 18.0;
const _maxFontSize = 48.0;
const _fontSizeStep = 2.0;

class RapModeFontSizeNotifier extends Notifier<double> {
  @override
  double build() => 28.0;

  void increase() =>
      state = (state + _fontSizeStep).clamp(_minFontSize, _maxFontSize);

  void decrease() =>
      state = (state - _fontSizeStep).clamp(_minFontSize, _maxFontSize);
}

final rapModeFontSizeProvider =
    NotifierProvider<RapModeFontSizeNotifier, double>(
      RapModeFontSizeNotifier.new,
    );
