// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:math';
import 'dart:html' as html;
import 'package:animated_background/animated_background.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

void main() => runApp(const LoginPage());

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      title: 'LoginPage - Flutter',
      home: Scaffold(
        body: Builder(
          builder: (context) => const LoginPageBackground(),
        ),
      ),
    );
  }
}

class LoginPageBackground extends StatefulWidget {
  const LoginPageBackground({super.key});

  @override
  State<LoginPageBackground> createState() => _LoginPageBackgroundState();
}

class _LoginPageBackgroundState extends State<LoginPageBackground>
    with TickerProviderStateMixin {
  final int _numberOfBubbles = 35;
  final List<Bubble> _bubbles = [];
  late AnimationController _controller;

  bool _remeber = false;
  final List<Color> colors = [
    Colors.blue.shade900,
    Colors.purple,
  ];

  @override
  void initState() {
    super.initState();

    final width = html.window.innerWidth!;
    final height = html.window.innerHeight!;
    final random = Random();

    for (int i = 0; i < _numberOfBubbles; i++) {
      _bubbles.add(
        Bubble()
          ..color = colors[random.nextInt(colors.length)]
              .withOpacity(0.05 + random.nextDouble() * 0.5)
          ..radius = 20 + random.nextInt(20).toDouble()
          ..position = Offset(
            random.nextDouble() * width,
            random.nextDouble() * height,
          ),
      );
    }
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 20000,
      ),
    )
      ..repeat()
      ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final BorderRadius borderRadius = BorderRadius.circular(25.0);
    return AnimatedBackground(
      vsync: this,
      behaviour: RandomParticleBehaviour(
        options: ParticleOptions(
          baseColor: colors[Random().nextInt(colors.length)],
          spawnMaxSpeed: 40.0,
          spawnMinSpeed: 20.0,
          spawnMaxRadius: 20.0,
          spawnMinRadius: 20.0,
          particleCount: 50,
        ),
      ),
      child: Stack(
        children: [
          ..._bubbles.map(
            (bubble) {
              return Positioned(
                left: bubble.position.dx,
                top: bubble.position.dy,
                child: Opacity(
                  opacity: bubble.color!.opacity,
                  child: Container(
                    width: bubble.radius! * 2,
                    height: bubble.radius! * 2,
                    decoration: BoxDecoration(
                      color: bubble.color,
                      borderRadius: borderRadius * 2,
                      boxShadow: [
                        BoxShadow(
                          color: bubble.color!.withOpacity(0.3),
                          blurRadius: bubble.radius! * 0.5,
                          spreadRadius: bubble.radius! * 0.1,
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          Center(
            child: GlassmorphicContainer(
              width: 350,
              height: 500,
              linearGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFffffff).withOpacity(0.15),
                  const Color(0xFFFFFFFF).withOpacity(0.05),
                ],
              ),
              blur: 2.5,
              border: 2.5,
              borderGradient: LinearGradient(
                colors: [
                  const Color(0xFFffffff).withOpacity(0.15),
                  const Color(0xFFFFFFFF).withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: 30,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Enter Email',
                        border: OutlineInputBorder(borderRadius: borderRadius),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Enter Password',
                        border: OutlineInputBorder(borderRadius: borderRadius),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: _remeber,
                          onChanged: (value) {
                            setState(() {
                              _remeber = !_remeber;
                            });
                          },
                        ),
                        const Text('Remember Me')
                      ],
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: colors,
                            begin: Alignment.topLeft,
                            end: Alignment.topRight,
                          ),
                          borderRadius: borderRadius,
                        ),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 25,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: borderRadius,
                            ),
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shadowColor: Colors.transparent,
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: const Text('Sign In'),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
