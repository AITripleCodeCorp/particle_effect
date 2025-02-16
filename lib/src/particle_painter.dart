import 'package:flutter/material.dart';
import 'dart:math';
import 'package:particle_effect/src/particle.dart';

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;

  ParticlePainter({
    required this.particles,
  });
  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      if (particle.particleImage == null) continue;

      particle.setPosition(
        particle.x.randomValueFromRange * size.width,
        particle.y.randomValueFromRange * size.height,
      );
      particle.update();

      var paint = Paint()
        ..color = Color.fromARGB(particle.opacity.toInt(), 255, 255, 255);

      canvas.save();
      canvas.translate(
          particle.x.randomValueFromRange, particle.y.randomValueFromRange);
      canvas.rotate(particle.rotation.randomValueFromRange * (pi / 180));

      // Pobranie wymiarów obrazka
      final imageWidth = particle.particleImage!.width.toDouble();
      final imageHeight = particle.particleImage!.height.toDouble();
      // Rysowanie obrazka przesuniętego o połowę szerokości i wysokości
      canvas.drawImage(
        particle.particleImage!,
        Offset(-imageWidth / 2, -imageHeight / 2),
        paint,
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
