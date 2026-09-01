import 'package:flutter/material.dart';
import 'dart:async';
import 'main_navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double loading = 0.0;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(
      const Duration(milliseconds: 30),
      (timer) {
        if (!mounted) return;

        setState(() {
          loading += 0.01;

          if (loading >= 1.0) {
            loading = 1.0;
            timer.cancel();

            Future.delayed(const Duration(milliseconds: 300), () {
              if (!mounted) return;
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const MainNavigation()),
              );
            });
          }
        });
      },
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBFC),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;

            return Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                Positioned(
                  left: -width * 0.48,
                  bottom: -height * 0.08,
                  child: Container(
                    width: width * 0.95,
                    height: width * 0.95,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFFFDCE5),
                    ),
                  ),
                ),
                Positioned(
                  right: -width * 0.45,
                  top: -width * 0.18,
                  child: Container(
                    width: width * 0.90,
                    height: width * 0.90,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFFFE8ED),
                    ),
                  ),
                ),
                Positioned(
                  right: width * 0.16,
                  top: height * 0.20,
                  child: Container(
                    width: width * 0.07,
                    height: width * 0.07,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFFFB8C8),
                    ),
                  ),
                ),
                Center(
                  child: Transform.translate(
                    offset: const Offset(0, -55),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Transform.translate(
                          offset: const Offset(10, 14),
                          child: const Text(
                            'ZZIP',
                            style: TextStyle(
                              fontSize: 145,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -9,
                              color: Color(0xFFA71943),
                              shadows: [
                                Shadow(
                                  offset: Offset(2, 4),
                                  blurRadius: 0,
                                  color: Color(0xFF851333),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Text(
                          'ZZIP',
                          style: TextStyle(
                            fontSize: 145,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -9,
                            color: Color(0xFFE43F68),
                            shadows: [
                              Shadow(
                                offset: Offset(1, 2),
                                blurRadius: 1,
                                color: Color(0xFFFF8FA7),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          right: -20,
                          top: -33,
                          child: Transform.rotate(
                            angle: 0.08,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Positioned(
                                  right: 19,
                                  top: 14,
                                  child: Text(
                                    'Z',
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF9E1743),
                                    ),
                                  ),
                                ),
                                const Text(
                                  'Z',
                                  style: TextStyle(
                                    fontSize: 38,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFFE43F68),
                                    shadows: [
                                      Shadow(
                                        offset: Offset(1, 2),
                                        blurRadius: 0,
                                        color: Color(0xFFA71943),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: width * 0.18,
                  right: width * 0.18,
                  bottom: height * 0.35,
                  child: Column(
                    children: [
                      Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFDCE5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: FractionallySizedBox(
                            widthFactor: loading,
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFE43F68),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 9),
                      Text(
                        'LOADING...',
                        style: TextStyle(
                          fontSize: width * 0.028,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                          color: const Color(0xFFE43F68),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: height * 0.045,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      Text(
                        'K-INSOMNIA',
                        style: TextStyle(
                          fontSize: width * 0.037,
                          fontWeight: FontWeight.w800,
                          letterSpacing: width * 0.012,
                          color: const Color(0xFF444444),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'HUNTERS',
                        style: TextStyle(
                          fontSize: width * 0.037,
                          fontWeight: FontWeight.w800,
                          letterSpacing: width * 0.012,
                          color: const Color(0xFFE43F68),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}