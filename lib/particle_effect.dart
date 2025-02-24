library particle_effect;

import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/scheduler.dart';
import 'src/particle.dart';
import 'src/particle_painter.dart';

export 'src/particle.dart';
export 'src/particle_painter.dart';

class ParticleEffect extends StatefulWidget {
  final int maxParticles;
  final Duration? particleInterval;
  final List<Particle> particles;

  const ParticleEffect({
    Key? key,
    this.maxParticles = 100,
    this.particleInterval,
    required this.particles,
  }) : super(key: key);

  @override
  _ParticleEffectState createState() => _ParticleEffectState();
}

class _ParticleEffectState extends State<ParticleEffect>
    with SingleTickerProviderStateMixin {
  List<Particle> particlesOnScreen = [];
  late final Ticker _ticker;
  Duration lastParticleTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    startTicker();
  }

  void onMaxParticlesChanged() {
    if (widget.maxParticles == 0) {
      for (var particle in particlesOnScreen) {
        particle.setToDispose();
      }
    }
  }

  void startTicker() {
    _ticker = createTicker((elapsed) {
      onMaxParticlesChanged();

      if (widget.particleInterval == null) {
        while (particlesOnScreen.length < widget.maxParticles) {
          particlesOnScreen.add(createParticle());
        }
      } else if (particlesOnScreen.length < widget.maxParticles &&
          elapsed - lastParticleTime >= widget.particleInterval!) {
        particlesOnScreen.add(createParticle());
        lastParticleTime = elapsed;
      }

      particlesOnScreen.removeWhere((p) => p.isFinished());
      setState(() {});
    });

    _ticker.start();
  }

  Particle createParticle() {
    assert(widget.particles.isNotEmpty);
    Particle particle =
        widget.particles[Random().nextInt(widget.particles.length)];
    return particle.clone();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: size.height,
      child: CustomPaint(
        painter: ParticlePainter(
          particles: particlesOnScreen,
        ),
      ),
    );
  }
}
