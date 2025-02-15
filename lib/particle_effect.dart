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
  final Duration particleInterval;
  final List<Particle> particles;

  const ParticleEffect({
    Key? key,
    this.maxParticles = 20,
    this.particleInterval = const Duration(milliseconds: 1000),
    required this.particles,
  }) : super(key: key);

  @override
  _ParticleEffectState createState() => _ParticleEffectState();
}

class _ParticleEffectState extends State<ParticleEffect>
    with SingleTickerProviderStateMixin {
  List<Particle> particlesOnScreen = [];
  late final Ticker _ticker;

  @override
  void initState() {
    super.initState();

    startTicker();
  }

  void startTicker() {
    Duration lastParticleTime = Duration.zero;
    _ticker = createTicker((elapsed) {
      if (particlesOnScreen.length < widget.maxParticles &&
          elapsed - lastParticleTime >= widget.particleInterval) {
        particlesOnScreen.add(creatParticle());
        lastParticleTime = elapsed;
      }

      particlesOnScreen.removeWhere((p) => p.isFinished());
      setState(() {});
    });

    _ticker.start();
  }

  Particle creatParticle() {
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
