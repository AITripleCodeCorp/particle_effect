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

import 'dart:math';
import 'dart:ui' as ui;
import 'dart:async';

import 'package:flutter/services.dart';

class Range {
  double first;
  double second;

  Range({required this.first, required this.second});
}

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
  RangeValue imageSize;
  double rotation;
  double rotationSpeed;
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
    Range? rangeImageSize,
    double? opacity,
    double? opacityChangeSpeed,
    Duration? lifeTimee,
    double? rotation,
    double? rotationSpeed,
    required this.particleImageAssetPath,
  })  : x = RangeValue(originalRange: rangeX ?? Range(first: 0, second: 1)),
        y = RangeValue(originalRange: rangeY ?? Range(first: 0, second: 1)),
        vx = RangeValue(
            originalRange: rangeVx ?? Range(first: -0.5, second: 0.5)),
        vy = RangeValue(
            originalRange: rangeVy ?? Range(first: -0.5, second: 0.5)),
        imageSize = RangeValue(
            originalRange: rangeImageSize ?? Range(first: 1, second: 1)),
        opacity = opacity ?? 255,
        opacityChangeSpeed = opacityChangeSpeed ?? 0,
        lifeTime = lifeTimee ?? Duration(seconds: 3),
        rotation = rotation ?? 1,
        rotationSpeed = rotationSpeed ?? 1 {
    loadImageFromAssets(particleImageAssetPath,
            scale: imageSize.randomValueFromRange)
        .then((image) {
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
      rangeImageSize: Range(
          first: imageSize.originalRange.first,
          second: imageSize.originalRange.second),
      opacity: opacity,
      opacityChangeSpeed: opacityChangeSpeed,
      lifeTimee: lifeTime,
      rotation: rotation,
      rotationSpeed: rotationSpeed,
      particleImageAssetPath: particleImageAssetPath,
    );
  }

  void update() {
    x.randomValueFromRange += vx.randomValueFromRange;
    y.randomValueFromRange += vy.randomValueFromRange;
    rotation += rotationSpeed;
    opacity -= opacityChangeSpeed;

    //When their life time is over make dissapear faster
    if (_shouldDispose) opacity -= 2;
    if (opacity < 0) opacity = 0;
  }


  void setToDispose() {
    _shouldDispose = true;
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

Future<ui.Image> loadImageFromAssets(String path, {double scale = 1.0}) async {
  final ByteData data = await rootBundle.load(path);
  final Uint8List list = data.buffer.asUint8List();
  final Completer<ui.Image> completer = Completer();

  ui.decodeImageFromList(list, (ui.Image img) async {
    ui.Image resizedImage = await resizeImage(
        img, (img.width * scale).toInt(), (img.height * scale).toInt());
    completer.complete(resizedImage);
  });

  return completer.future;
}

Future<ui.Image> resizeImage(
    ui.Image image, int targetWidth, int targetHeight) async {
  final ui.PictureRecorder recorder = ui.PictureRecorder();
  final ui.Canvas canvas = ui.Canvas(recorder);

  final ui.Paint paint = ui.Paint()..filterQuality = ui.FilterQuality.high;

  canvas.drawImageRect(
    image,
    Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
    Rect.fromLTWH(0, 0, targetWidth.toDouble(), targetHeight.toDouble()),
    paint,
  );

  final ui.Picture picture = recorder.endRecording();
  return await picture.toImage(targetWidth, targetHeight);
}
