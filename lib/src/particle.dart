import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:async';

import 'package:flutter/services.dart';

class Pair {
  double first;
  double second;

  Pair({required this.first, required this.second});
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

class Particle {
  double x;
  double y;
  double vx;
  double vy;
  double opacity;
  double opacityChangeSpeed;
  Duration lifeTime;
  ui.Image? particleImage; // Make it nullable for async loading
  String particleImageAssetPath;
  Timer? _lifeTimer;

  bool _isPosSetted = false;
  bool _shouldDispose = false;

  // Constructor updated to accept a future for the image
  Particle({
    Pair? rangeX,
    Pair? rangeY,
    Pair? rangeVx,
    Pair? rangeVy,
    double? opacity,
    double? opacityChangeSpeed,
    Duration? lifeTimee,
    required this.particleImageAssetPath,
  })  : x = doubleInRange(rangeX ?? Pair(first: 0, second: 1)),
        y = doubleInRange(rangeY ?? Pair(first: 0, second: 1)),
        vx = doubleInRange(rangeVx ?? Pair(first: -0.5, second: 0.5)),
        vy = doubleInRange(rangeVy ?? Pair(first: -0.5, second: 0.5)),
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

  // Update method to handle particle movement and fading
  void update() {
    x += vx;
    y += vy;
    opacity -= opacityChangeSpeed;
    if (_shouldDispose) opacityChangeSpeed += 2;
  }

  // Set position only once for the particle
  setPosition(double xPos, double yPos) {
    if (!_isPosSetted) {
      x = xPos;
      y = yPos;
      _isPosSetted = true;
    }
  }

  // Check if particle is finished (based on opacity or lifetime)
  bool isFinished() {
    return opacity <= 0 || opacity > 255;
  }

  // Dispose timer when done
  void dispose() {
    _lifeTimer?.cancel();
  }
}

// Helper function to get a random value in the specified range
double doubleInRange(Pair range) {
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
