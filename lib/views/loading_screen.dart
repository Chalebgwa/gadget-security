import "package:flutter/material.dart";
import 'dart:math';

class LoadingScreen extends StatefulWidget {
  final double radius;
  final double dotRadius;

  const LoadingScreen({super.key, this.radius = 30.0, this.dotRadius = 3.0});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late Animation<double> animationRotation;
  late Animation<double> animationRadiusIn;
  late Animation<double> animationRadiusOut;
  late AnimationController controller;

  double radius = 0;
  double dotRadius = 0;

  @override
  void initState() {
    super.initState();

    radius = widget.radius;
    dotRadius = widget.dotRadius;

    controller = AnimationController(
      lowerBound: 0.0,
      upperBound: 1.0,
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    animationRotation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(
          0.0,
          1.0,
          curve: Curves.linear,
        ),
      ),
    );

    animationRadiusIn = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.75, 1.0, curve: Curves.elasticIn),
      ),
    );

    animationRadiusOut = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.25, curve: Curves.elasticOut),
      ),
    );

    controller.addListener(() {
      setState(() {
        if (controller.value >= 0.75 && controller.value <= 1.0) {
          radius = widget.radius * animationRadiusIn.value;
        } else if (controller.value >= 0.0 && controller.value <= 0.25) {
          radius = widget.radius * animationRadiusOut.value;
        }
      });
    });

    controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade50,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo or icon
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.purple.shade100,
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(
                Icons.security,
                size: 50,
                color: Colors.purple.shade600,
              ),
            ),
            const SizedBox(height: 30),
            
            // App name
            Text(
              'Gadget Security',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.purple.shade700,
              ),
            ),
            const SizedBox(height: 8),
            
            // Tagline
            Text(
              'Protecting your digital life',
              style: TextStyle(
                fontSize: 14,
                color: Colors.purple.shade400,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 40),
            
            // Custom loading animation
            SizedBox(
              width: 100.0,
              height: 100.0,
              child: Center(
                child: RotationTransition(
                  turns: animationRotation,
                  child: Center(
                    child: Stack(
                      children: <Widget>[
                        Transform.translate(
                          offset: const Offset(0.0, 0.0),
                          child: Dot(
                            radius: radius,
                            color: Colors.transparent,
                          ),
                        ),
                        for (int i = 0; i < 8; i++)
                          Transform.translate(
                            offset: Offset(
                              radius * cos(i * pi / 4),
                              radius * sin(i * pi / 4),
                            ),
                            child: Dot(
                              radius: dotRadius,
                              color: Colors.purple.shade300,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Loading text
            Text(
              'Loading...',
              style: TextStyle(
                fontSize: 14,
                color: Colors.purple.shade300,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class Dot extends StatelessWidget {
  final double radius;
  final Color color;

  const Dot({super.key, required this.radius, required this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: radius,
        height: radius,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
