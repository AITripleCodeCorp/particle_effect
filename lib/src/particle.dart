import 'dart:math';
import 'dart:ui' as ui;
import 'dart:async';

import 'package:flutter/services.dart';

class Range {
  double first;
  double second;

  Range({required this.first, required this.second});
}

/*
 A class representing a single particle in a particle system.
 It holds information about the particle's position, velocity, opacity, lifetime, and its image.

 The particle's behavior, such as movement and fading, is handled within the `update` method.
 The particle is marked for disposal once its lifetime or opacity reaches zero.
 Parameters:
 - `rangeX`: The range for the X position of the particle. Defaults to `(0, 1)`. Value between 0,1.
 - `rangeY`: The range for the Y position of the particle. Defaults to `(0, 1)`. Value between 0,1.
 - `rangeVx`: The range for the X velocity of the particle. Defaults to `(-0.5, 0.5)`. How fast it will move in the X direction. Any value.
 - `rangeVy`: The range for the Y velocity of the particle. Defaults to `(-0.5, 0.5)`. How fast it will move in the Y direction. Any Value.
 - `opacity`: The initial opacity of the particle. Defaults to `255`.
 - `opacityChangeSpeed`: The rate at which the opacity of the particle decreases. Defaults to `0`.
 - `lifeTimee`: The lifetime of the particle. Defaults to `Duration(seconds: 3)`.
 - `particleImage`: The image representing the particle.

 
Coordinates of a screen (x,y)
  (0,0)______________________(1,0) 
    |                          |     
    |                          |
    |                          |
    |                          |
    |                          |
  (0,1)______________________(1,1)
 */
class RangeValue {
  Range originalRange;
  double randomValueFromRange;

  RangeValue({required this.originalRange})
      : randomValueFromRange = doubleInRange(originalRange);
}

class Particle {
  RangeValue x;
  RangeValue y;
  RangeValue vx;
  RangeValue vy;
  double opacity;
  double opacityChangeSpeed;
  Duration lifeTime;
  ui.Image? particleImage;
  String particleImageAssetPath;
  Timer? _lifeTimer;

  bool _isPosSetted = false;
  bool _shouldDispose = false;

  Particle({
    Range? rangeX,
    Range? rangeY,
    Range? rangeVx,
    Range? rangeVy,
    double? opacity,
    double? opacityChangeSpeed,
    Duration? lifeTimee,
    required this.particleImageAssetPath,
  })  : x = RangeValue(originalRange: rangeX ?? Range(first: 0, second: 1)),
        y = RangeValue(originalRange: rangeY ?? Range(first: 0, second: 1)),
        vx = RangeValue(
            originalRange: rangeVx ?? Range(first: -0.5, second: 0.5)),
        vy = RangeValue(
            originalRange: rangeVy ?? Range(first: -0.5, second: 0.5)),
        opacity = opacity ?? 255,
        opacityChangeSpeed = opacityChangeSpeed ?? 0,
        lifeTime = lifeTimee ?? Duration(seconds: 3) {
    loadImageFromAssets(particleImageAssetPath).then((image) {
      particleImage = image;
    });
    _lifeTimer = Timer(Duration(milliseconds: lifeTime.inMilliseconds), () {
      _shouldDispose = true;
    });
  }

  Particle clone() {
    return Particle(
      rangeX:
          Range(first: x.originalRange.first, second: x.originalRange.second),
      rangeY:
          Range(first: y.originalRange.first, second: y.originalRange.second),
      rangeVx:
          Range(first: vx.originalRange.first, second: vx.originalRange.second),
      rangeVy:
          Range(first: vy.originalRange.first, second: vy.originalRange.second),
      opacity: opacity,
      opacityChangeSpeed: opacityChangeSpeed,
      lifeTimee: lifeTime,
      particleImageAssetPath: particleImageAssetPath,
    );
  }

  void update() {
    x.randomValueFromRange += vx.randomValueFromRange;
    y.randomValueFromRange += vy.randomValueFromRange;
    opacity -= opacityChangeSpeed;
    if (_shouldDispose) opacityChangeSpeed += 2;
  }

  setPosition(double xPos, double yPos) {
    if (!_isPosSetted) {
      x.randomValueFromRange = xPos;
      y.randomValueFromRange = yPos;
      _isPosSetted = true;
    }
  }

  bool isFinished() {
    return opacity <= 0 || opacity > 255;
  }

  void dispose() {
    _lifeTimer?.cancel();
  }
}

// Helper function to get a random value in the specified range
double doubleInRange(Range range) {
  var random = Random();
  return range.first + (range.second - range.first) * random.nextDouble();
}

// Load image from assets asynchronously
Future<ui.Image> loadImageFromAssets(String path) async {
  final ByteData data = await rootBundle.load(path);
  final Uint8List list = data.buffer.asUint8List();
  final Completer<ui.Image> completer = Completer();
  ui.decodeImageFromList(list, (ui.Image img) {
    completer.complete(img);
  });
  return completer.future;
}
