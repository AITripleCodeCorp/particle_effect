import 'package:flutter/material.dart';
import 'package:particle_effect/particle_effect.dart'; // Importujemy Twój pakiet

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

class ParticleEffectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Particle Effect Example'),
      ),
      body: Stack(
        children: [
          ParticleEffect(
            maxParticles: 50,
            particleInterval: Duration(milliseconds: 200),
            particles: [
              Particle(
                // rangeX: Range(first: 0.5, second: 0.5),
                // rangeY: Range(first: 0.5, second: 0.5),
                // rangeVx: Range(first: -0.3, second: 0.3),
                // rangeVy: Range(first: 0.0, second: 1),
                // lifeTimee: Duration(seconds: 3),
                particleImageAssetPath:
                    'assets/particle.png', // Używaj assetu cząsteczek
              ),
              //Particle(particleImageAssetPath: 'assets/particle_2.png')
            ],
          ),
          Center(
            child: Text(
              'Particle Effect Below!',
              style: TextStyle(fontSize: 24, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
