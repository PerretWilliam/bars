import 'package:flutter/material.dart';
import 'package:just_waveform/just_waveform.dart';

class WaveformView extends StatelessWidget {
  const WaveformView({
    required this.waveform,
    required this.position,
    required this.duration,
    required this.onSeek,
    super.key,
  });

  final Waveform waveform;
  final Duration position;
  final Duration duration;
  final ValueChanged<Duration> onSeek;

  void _handleTap(BoxConstraints constraints, Offset localPosition) {
    if (duration.inMilliseconds == 0) return;
    final fraction = (localPosition.dx / constraints.maxWidth).clamp(0.0, 1.0);
    onSeek(duration * fraction);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTapUp: (details) => _handleTap(constraints, details.localPosition),
          child: CustomPaint(
            size: Size(constraints.maxWidth, constraints.maxHeight),
            painter: _WaveformPainter(
              waveform: waveform,
              progress: duration.inMilliseconds == 0
                  ? 0
                  : position.inMilliseconds / duration.inMilliseconds,
              color: Theme.of(context).colorScheme.primary,
              playedColor: Theme.of(context).colorScheme.secondary,
            ),
          ),
        );
      },
    );
  }
}

class _WaveformPainter extends CustomPainter {
  _WaveformPainter({
    required this.waveform,
    required this.progress,
    required this.color,
    required this.playedColor,
  });

  final Waveform waveform;
  final double progress;
  final Color color;
  final Color playedColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (waveform.length == 0) return;

    const sampleAmplitude = 32768;
    final middle = size.height / 2;
    final playedWidth = size.width * progress;

    for (var x = 0.0; x < size.width; x += 1) {
      final pixelIndex = (x / size.width * waveform.length).toInt();
      final min = waveform.getPixelMin(pixelIndex) / sampleAmplitude;
      final max = waveform.getPixelMax(pixelIndex) / sampleAmplitude;
      final paint = Paint()
        ..color = x <= playedWidth ? playedColor : color
        ..strokeWidth = 1;
      canvas.drawLine(
        Offset(x, middle + min * middle),
        Offset(x, middle + max * middle),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _WaveformPainter oldDelegate) {
    return oldDelegate.waveform != waveform ||
        oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.playedColor != playedColor;
  }
}
