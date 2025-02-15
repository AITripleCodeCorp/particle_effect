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
      particle.setPosition(particle.x * size.width, particle.y * size.height);

      particle.update();
      var paint = Paint()
        ..color = Color.fromARGB(particle.opacity.toInt(), 255, 255, 255);

      if (particle.particleImage != null) {
        canvas.drawImage(
          particle.particleImage!,
          Offset(particle.x, particle.y),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
