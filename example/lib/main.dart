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
          Center(
            child: Text(
              'Particle Effect Below!',
              style: TextStyle(fontSize: 24, color: Colors.black),
            ),
          ),
          ParticleEffect(
            maxParticles: 30,
            particleInterval: Duration(milliseconds: 200),
            particles: [
              Particle(
                particleImageAssetPath:
                    'assets/particle.png', // Używaj assetu cząsteczek
              ),
            ],
          ),
        ],
      ),
    );
  }
}
