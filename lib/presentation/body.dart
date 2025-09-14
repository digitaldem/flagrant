import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../domain/effigy.dart';
import '../provider/settings.dart';

class Body extends StatefulWidget {
  /// Effigy assets data.
  final IEffigy effigy;

  /// Number of embers.
  final int emberCount;

  /// Floating duration of embers (seconds).
  final int emberFloatingDuration;

  /// Number of blobs to scatter.
  final int blobCount;

  /// General blob diameter (pixels).
  final int blobSize;

  /// General fade duration per blob (seconds).
  final int blobFadeDuration;

  const Body({
    super.key,
    required this.effigy,
    this.emberCount = 50,
    this.emberFloatingDuration = 30,
    this.blobCount = 50,
    this.blobSize = 80,
    this.blobFadeDuration = 10,
  });

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> with TickerProviderStateMixin {
  static const int _dissolveRestartDelaySeconds = 10;
  late final AnimationController _emberController;
  //late final Animation<double> _emberAnimation;
  late final AnimationController _dissolveController;
  late final Animation<double> _dissolveAnimation;

  final int _sessionSalt = DateTime.now().microsecondsSinceEpoch & 0x7fffffff;
  final math.Random _random = math.Random();

  final List<_Ember> _embers = [];
  final List<_Blob> _blobs = [];
  int _blobSeed = 0;
  int? _blobSeedPrevious;
  Size? _blobSpace;

  bool _fadeEnabled = false;
  bool _fadeEnabledPrevious = false;

  @override
  void initState() {
    super.initState();

    _emberController =
        AnimationController(duration: Duration(seconds: widget.emberFloatingDuration), vsync: this)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _generateEmbers();
              _emberController.forward(from: 0);
            }
          })
          ..forward();
    _generateEmbers();

    _dissolveController = AnimationController(duration: const Duration(milliseconds: 1), vsync: this)..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (!_fadeEnabled) {
          return;
        }
        Future.delayed(const Duration(seconds: _dissolveRestartDelaySeconds), () {
          if (!mounted || !_fadeEnabled) {
            return;
          }
          _blobSeed++;
          _dissolveController.forward(from: 0);
          setState(() {});
        });
      }
    });
    _dissolveAnimation = CurvedAnimation(parent: _dissolveController, curve: Curves.linear);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: true);
    _fadeEnabledPrevious = _fadeEnabled;
    _fadeEnabled = settingsProvider.fadeEnabled;

    if (!_fadeEnabledPrevious && _fadeEnabled) {
      _blobSeed++;
    }

    final newDissolve = _fadeEnabled ? Duration(minutes: settingsProvider.fadeMinutes.clamp(1, 60)) : const Duration(milliseconds: 1);

    if (_dissolveController.duration != newDissolve) {
      _blobSeed++;
      _dissolveController.duration = newDissolve;
      if (_fadeEnabled) {
        _dissolveController.forward(from: 0);
      } else {
        _dissolveController.value = 0.0;
      }
    }
  }

  @override
  void dispose() {
    _dissolveController.dispose();
    _emberController.dispose();
    super.dispose();
  }

  void restart() {
    _dissolveController.forward(from: 0);
    _emberController.forward(from: 0);
    _generateEmbers();
  }

  void _generateEmbers() {
    const colors = [Colors.orange, Colors.red, Colors.deepOrange, Colors.amber, Color(0xFFFF4500)];

    _embers.clear();
    for (int i = 0; i < widget.emberCount; i++) {
      _embers.add(
        _Ember(
          x: _random.nextDouble(),
          y: _random.nextDouble(),
          size: _random.nextDouble() * 3 + 1,
          delay: _random.nextDouble() * 0.6,
          velocity: Offset((_random.nextDouble() - 0.5) * 120, -_random.nextDouble() * 160 - 60),
          color: colors[_random.nextInt(colors.length)],
        ),
      );
    }
  }

  void _generateBlobs() {
    final size = MediaQuery.sizeOf(context);
    if (_blobSpace == size && _blobSeedPrevious == _blobSeed && _blobs.isNotEmpty) {
      return;
    }

    if (!_fadeEnabled) {
      _blobs.clear();
      _blobSpace = size;
      return;
    }

    final blobSize = widget.blobSize.toDouble();
    final blobFadeDuration = widget.blobFadeDuration.toDouble();
    final rng = math.Random(_sessionSalt ^ _blobSeed ^ size.width.toInt() ^ (size.height.toInt() << 16));
    final w = size.width, h = size.height;

    final List<_Blob> blobs = [];
    final minDist = (blobSize * 0.25);
    int attempts = 0, maxAttempts = widget.blobCount * 25;

    final totalSec = (_dissolveController.duration?.inMilliseconds ?? 0) / 1000.0;
    while (blobs.length < widget.blobCount && attempts < maxAttempts) {
      attempts++;

      // Variable position
      double cx = rng.nextDouble() * w;
      double cy = rng.nextDouble() * h;
      cx = (cx + flowDx(cx, cy)).clamp(0.0, w);
      cy = (cy + flowDy(cx, cy)).clamp(0.0, h);

      // Variable radius around general size
      final radiusPx = (blobSize * (0.4 + rng.nextDouble() * 0.6)).clamp(2.0, blobSize * 1.2);

      // Variable fade around general duration
      final fadeSec = (blobFadeDuration * (0.4 + rng.nextDouble() * 0.6)).clamp(2.0, blobFadeDuration * 1.2);

      bool ok = true;
      for (int i = blobs.length - 1; i >= 0 && i > blobs.length - 40; i--) {
        final dx = blobs[i].cx - cx, dy = blobs[i].cy - cy;
        if (dx * dx + dy * dy < (minDist * minDist)) {
          ok = false;
          break;
        }
      }
      if (!ok) {
        continue;
      }

      final n = _perlinish(cx / 110, cy / 110) * 0.5 + _perlinish(cx / 55, cy / 55) * 0.3;
      final noise01 = (n + 1) * 0.5;
      final bottomBias = (cy / h).clamp(0.0, 1.0);
      const bottomBiasWeight = 0.12;
      final activation = noise01 * (1.0 - bottomBiasWeight) + bottomBias * bottomBiasWeight;
      final startSec = activation * (totalSec * 0.9);
      final seed = rng.nextInt(0x7fffffff);

      blobs.add(_Blob(cx: cx, cy: cy, r: radiusPx, startSec: startSec, fadeSec: fadeSec, seed: seed));
    }

    _blobs
      ..clear()
      ..addAll(blobs);
    _blobSeedPrevious = _blobSeed;
    _blobSpace = size;
  }

  @override
  Widget build(BuildContext context) {
    _generateBlobs();

    return Stack(
      fit: StackFit.expand,
      children: [
        AnimatedBuilder(
          animation: Listenable.merge([_dissolveController, _emberController]),
          builder: (context, _) {
            final emberPeriodSeconds = widget.emberFloatingDuration.toDouble();
            final t = _dissolveAnimation.value;
            final elapsedMs = _emberController.lastElapsedDuration?.inMilliseconds ?? 0;
            final elapsedSeconds = elapsedMs / 1000.0;
            final totalSec = (_dissolveController.duration?.inMilliseconds ?? 0) / 1000.0;
            final nowSec = t * totalSec;

            return SizedBox.expand(
              child: Stack(
                fit: StackFit.expand,
                clipBehavior: Clip.none,
                children: [
                  Image.asset(widget.effigy.image, fit: BoxFit.cover),

                  // Blobs
                  if (_fadeEnabled)
                    Positioned.fill(
                      child: RepaintBoundary(
                        child: CustomPaint(
                          painter: _BlobFadePainter(blobs: _blobs, nowSec: nowSec, curve: Curves.easeIn, wobbleTime: elapsedSeconds),
                        ),
                      ),
                    ),

                  // Fade
                  if (_fadeEnabled) IgnorePointer(child: Opacity(opacity: t.clamp(0.0, 1.0), child: const ColoredBox(color: Colors.black))),

                  // Embers
                  if (widget.emberCount > 0)
                    Positioned.fill(
                      child: RepaintBoundary(
                        child: CustomPaint(
                          painter: _EmberPainter(embers: _embers, elapsedSeconds: elapsedSeconds, periodSeconds: emberPeriodSeconds),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Transform(
            alignment: Alignment.bottomCenter,
            transform: Matrix4.diagonal3Values(widget.effigy.xScale, widget.effigy.yScale, 1.0),
            child: Lottie.asset(
              widget.effigy.lottie,
              fit: BoxFit.cover,
              repeat: true,
              animate: true,
              frameRate: FrameRate.max,
              errorBuilder: (ctx, err, _) => const CircularProgressIndicator(),
            ),
          ),
        ),
      ],
    );
  }

  double flowDx(double x, double y) {
    return math.sin(x * 0.007 + _blobSeed * 0.13) * 8.0 + math.sin(y * 0.011 + _sessionSalt * 0.17) * 4.0;
  }

  double flowDy(double x, double y) {
    return math.cos(y * 0.009 + _blobSeed * 0.19) * 8.0 + math.cos(x * 0.013 + _sessionSalt * 0.23) * 4.0;
  }

  static double _perlinish(double x, double y) {
    return math.sin(x * 2.1) * math.cos(y * 1.7) + math.sin(x * 0.8) * math.cos(y * 2.9) + 0.5 * math.sin(x * 4.2) * math.cos(y * 3.3);
  }
}

class _Ember {
  final double x, y, size, delay;
  final Offset velocity;
  final Color color;
  _Ember({required this.x, required this.y, required this.size, required this.delay, required this.velocity, required this.color});
}

class _EmberPainter extends CustomPainter {
  final List<_Ember> embers;
  final double elapsedSeconds;
  final double periodSeconds;

  _EmberPainter({required this.embers, required this.elapsedSeconds, required this.periodSeconds});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..isAntiAlias = true;

    for (final e in embers) {
      final local = ((elapsedSeconds - e.delay * periodSeconds) / periodSeconds);
      final frac = local - local.floor(); // fractional part 0..1

      final start = Offset(e.x * size.width, e.y * size.height);
      final pos = (start + e.velocity * frac) + Offset(0, 60.0 * frac * frac);

      final opacity = (1.0 - frac).clamp(0.0, 1.0);
      final currentSize = (e.size * (1.0 - frac * 0.3)).clamp(0.0, double.infinity);
      if (opacity <= 0 || currentSize <= 0) continue;

      // Outer glow
      paint.color = e.color.withValues(alpha: opacity * 0.3);
      canvas.drawCircle(pos, currentSize * 2, paint);

      // Main ember
      paint.color = e.color.withValues(alpha: opacity);
      canvas.drawCircle(pos, currentSize, paint);

      // Core
      paint.color = Colors.white.withValues(alpha: opacity * 0.8);
      canvas.drawCircle(pos, currentSize * 0.3, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _EmberPainter old) =>
      old.embers != embers || old.elapsedSeconds != elapsedSeconds || old.periodSeconds != periodSeconds;
}

class _Blob {
  final double cx, cy, r;
  final double startSec;
  final double fadeSec;
  final int seed;
  const _Blob({required this.cx, required this.cy, required this.r, required this.startSec, required this.fadeSec, required this.seed});
}

class _BlobFadePainter extends CustomPainter {
  final List<_Blob> blobs;
  final double nowSec;
  final Curve curve;
  final double wobbleTime;
  _BlobFadePainter({required this.blobs, required this.nowSec, required this.curve, this.wobbleTime = 0.0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..isAntiAlias = true
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 0.6);

    for (final b in blobs) {
      final local = ((nowSec - b.startSec) / b.fadeSec);
      if (local <= 0) {
        continue;
      }

      double a = local >= 1 ? 0.4 : curve.transform(local.clamp(0.0, 1.0)) * 0.4;
      if (a <= 0) {
        continue;
      }

      paint.color = Colors.black.withValues(alpha: a);
      final path = _makeWavyBlob(
        center: Offset(b.cx, b.cy),
        baseR: b.r,
        seed: b.seed,
        points: 48,
        amp: 0.14,
        freq: 6.0,
        wobbleTime: wobbleTime,
        wobbleAmp: 0.06,
      );
      canvas.drawPath(path, paint);
    }
  }

  Path _makeWavyBlob({
    required Offset center,
    required double baseR,
    required int seed,
    required int points,
    required double amp,
    required double freq,
    required double wobbleTime,
    required double wobbleAmp,
  }) {
    final path = Path();
    if (baseR <= 0) {
      return path;
    }

    Offset polar(double rr, double ang) => center + Offset(math.cos(ang) * rr, math.sin(ang) * rr);

    final double step = (2 * math.pi) / points;
    double angle = 0.0;

    double r0 = _perturbedRadius(baseR, angle, seed, amp, wobbleTime, wobbleAmp, freq);
    path.moveTo(center.dx + math.cos(angle) * r0, center.dy + math.sin(angle) * r0);

    for (int i = 1; i <= points; i++) {
      angle = i * step;
      final r = _perturbedRadius(baseR, angle, seed, amp, wobbleTime, wobbleAmp, freq);
      final p = polar(r, angle);
      path.lineTo(p.dx, p.dy);
    }

    path.close();
    return path;
  }

  double _perturbedRadius(double baseR, double angle, int seed, double amp, double wobbleTime, double wobbleAmp, double freq) {
    final s = seed.toDouble();
    double n = 0.0;
    n += math.sin(angle * freq + s * 0.17) * 0.55;
    n += math.sin(angle * (freq * 0.5) + s * 0.31) * 0.3;
    n += math.sin(angle * (freq * 1.9) + s * 0.07) * 0.15;
    n *= amp;

    final wob = wobbleAmp * math.sin((angle * (freq * 0.6)) + wobbleTime * 1.3 + s * 0.13);
    final scale = 1.0 + n + wob;
    return baseR * scale.clamp(0.6, 1.6);
  }

  @override
  bool shouldRepaint(covariant _BlobFadePainter old) =>
      old.blobs != blobs || old.nowSec != nowSec || old.curve != curve || old.wobbleTime != wobbleTime;
}
