import 'package:flutter/material.dart';
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

      canvas.drawImage(
        particle.particleImage!,
        Offset(
            particle.x.randomValueFromRange, particle.y.randomValueFromRange),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
