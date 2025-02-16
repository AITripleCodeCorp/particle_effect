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

      particle.setPosition(particle.x.randomValueFromRange * size.width,
          particle.y.randomValueFromRange * size.height);

      particle.update();
      var paint = Paint()
        ..color = Color.fromARGB(particle.opacity.toInt(), 255, 255, 255);

      double centerX = particle.x.randomValueFromRange;
      double centerY = particle.y.randomValueFromRange;

      canvas.save();
      canvas.translate(centerX, centerY);
      canvas.rotate(particle.rotation * (pi / 180));
      canvas.translate(-centerX, -centerY);

      canvas.drawImage(
        particle.particleImage!,
        Offset(centerX, centerY),
        paint,
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
