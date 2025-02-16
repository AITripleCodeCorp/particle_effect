import 'package:flutter/material.dart';
import 'package:particle_effect/particle_effect.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Particle Effect Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ParticleEffectPage(),
    );
  }
}

class ParticleEffectPage extends StatefulWidget {
  @override
  State<ParticleEffectPage> createState() => _ParticleEffectPageState();
}

class _ParticleEffectPageState extends State<ParticleEffectPage> {
  int maxParticles = 20;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Particle Effect Example'),
      ),
      body: Stack(
        children: [
          ParticleEffect(
            maxParticles: maxParticles,
            particleInterval: Duration(milliseconds: 500),
            particles: [
              Particle(
                rangeX: Range(first: 0, second: 1),
                rangeY: Range(first: 0, second: 1),
                rangeVx: Range(first: -0.5, second: 0.5),
                rangeVy: Range(first: -0.5, second: 0.5),
                rotation: Range(first: -360, second: 360),
                rotationSpeed: Range(first: -1, second: 1),
                rangeImageSize: Range(first: 0.1, second: 0.3),
                lifeTimee: Duration(seconds: 10),
                particleImageAssetPath: 'assets/particle_big.png',
              ),
            ],
          ),
          Center(
            child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    maxParticles == 0 ? maxParticles = 20 : maxParticles = 0;
                  });
                },
                child: Text(maxParticles == 20
                    ? "Kill all Particles"
                    : "Revive Particles")),
          )
        ],
      ),
    );
  }
}
