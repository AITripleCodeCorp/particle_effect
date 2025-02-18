import 'package:flutter/material.dart';
import 'package:particle_effect/particle_effect.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool showSliders = true;

  // Zakresy dla cząsteczek
  Range rangeX = Range(first: 0, second: 1);
  Range rangeY = Range(first: 0, second: 1);
  Range rangeVx = Range(first: 0, second: 0);
  Range rangeVy = Range(first: 2, second: 2);
  Range rangeImageSize = Range(first: 0.1, second: 0.3);
  Range rotation = Range(first: -45, second: 45);
  Range rotationSpeed = Range(first: -0.1, second: 0.1);
  int maxParticles = 20;
  int maxParticleLifeTime = 2;

  Widget createSliders() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Opacity(
          opacity: 0.5,
          child: Column(
            children: [
              sliderWidget("Ilość cząsteczek", maxParticles.toDouble(),
                  Range(first: 1, second: 100), (value) {
                setState(() => maxParticles = value.toInt());
              }),
              sliderWidget(
                  "Czas życia cząsteczki cząsteczek [s]",
                  maxParticleLifeTime.toDouble(),
                  Range(first: 1, second: 100), (value) {
                setState(() => maxParticleLifeTime = value.toInt());
              }),
              rangeSliderWidget(
                "Zakres X: ${rangeX.first.toStringAsFixed(2)} - ${rangeX.second.toStringAsFixed(2)}",
                rangeX,
                Range(first: 0, second: 1),
                (value) {
                  setState(() =>
                      rangeX = Range(first: value.start, second: value.end));
                },
              ),
              rangeSliderWidget(
                "Zakres Y: ${rangeY.first.toStringAsFixed(2)} - ${rangeY.second.toStringAsFixed(2)}",
                rangeY,
                Range(first: 0, second: 1),
                (value) {
                  setState(() =>
                      rangeY = Range(first: value.start, second: value.end));
                },
              ),
              rangeSliderWidget(
                "Prędkość X: ${rangeVx.first.toStringAsFixed(2)} - ${rangeVx.second.toStringAsFixed(2)}",
                rangeVx,
                Range(first: -3, second: 3),
                (value) {
                  setState(() =>
                      rangeVx = Range(first: value.start, second: value.end));
                },
              ),
              rangeSliderWidget(
                "Prędkość Y: ${rangeVy.first.toStringAsFixed(2)} - ${rangeVy.second.toStringAsFixed(2)}",
                rangeVy,
                Range(first: -3, second: 3),
                (value) {
                  setState(() =>
                      rangeVy = Range(first: value.start, second: value.end));
                },
              ),
              rangeSliderWidget(
                "Rozmiar Obrazu: ${rangeImageSize.first.toStringAsFixed(2)} - ${rangeImageSize.second.toStringAsFixed(2)}",
                rangeImageSize,
                Range(first: 0, second: 2),
                (value) {
                  setState(() => rangeImageSize =
                      Range(first: value.start, second: value.end));
                },
              ),
              rangeSliderWidget(
                "Startowy Obrót: ${rotation.first.toStringAsFixed(2)}° - ${rotation.second.toStringAsFixed(2)}°",
                rotation,
                Range(first: -360, second: 360),
                (value) {
                  setState(() =>
                      rotation = Range(first: value.start, second: value.end));
                },
              ),
              rangeSliderWidget(
                "Szybkość Obrotu: ${rotationSpeed.first.toStringAsFixed(2)} - ${rotationSpeed.second.toStringAsFixed(2)}",
                rotationSpeed,
                Range(first: -3, second: 3),
                (value) {
                  setState(() => rotationSpeed =
                      Range(first: value.start, second: value.end));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget rangeSliderWidget(String label, Range range, Range minMAx,
      ValueChanged<RangeValues> onChanged) {
    return Column(
      children: [
        Text(label),
        RangeSlider(
          values: RangeValues(range.first, range.second),
          labels: RangeLabels(
              range.first.toStringAsFixed(2), range.second.toStringAsFixed(2)),
          min: minMAx.first,
          max: minMAx.second,
          divisions: 100,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget sliderWidget(
      String label, double value, Range minMax, Function(double) onChanged) {
    return Column(
      children: [
        Text("$label: ${value.toStringAsFixed(2)}"),
        Slider(
          value: value,
          min: minMax.first,
          max: minMax.second,
          divisions: 100,
          label: value.toStringAsFixed(2),
          onChanged: onChanged,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ParticleEffect(
            maxParticles: maxParticles,
            particleInterval: Duration(milliseconds: 100),
            particles: [
              Particle(
                rangeX: rangeX,
                rangeY: rangeY,
                rangeVx: rangeVx,
                rangeVy: rangeVy,
                rangeImageSize: rangeImageSize,
                rotation: rotation,
                rotationSpeed: rotationSpeed,
                opacity: 255, //// Should be A range
                lifeTimee:
                    Duration(seconds: maxParticleLifeTime), // Should be A range
                particleImageAssetPath: 'assets/particle_big.png',
              ),
            ],
          ),
          Positioned.fill(
            child: CustomPaint(
              painter: RectanglePainter(rangeX, rangeY),
            ),
          ),
          showSliders
              ? Align(
                  alignment: Alignment.bottomCenter,
                  child: createSliders(),
                )
              : SizedBox(),
          Positioned(
            right: 0,
            top: 30,
            child: Checkbox(
              value: showSliders,
              onChanged: (value) {
                setState(() {
                  showSliders = value ?? false;
                });
              },
            ),
          )
        ],
      ),
    );
  }
}

class RectanglePainter extends CustomPainter {
  final Range rangeX;
  final Range rangeY;

  RectanglePainter(this.rangeX, this.rangeY);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint rectPaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke;

    double x1 = rangeX.first * size.width;
    double x2 = rangeX.second * size.width;
    double y1 = rangeY.first * size.height;
    double y2 = rangeY.second * size.height;

    // Rysowanie prostokąta
    Rect rect = Rect.fromLTRB(x1, y1, x2, y2);
    canvas.drawRect(rect, rectPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
