import 'package:flutter/material.dart';
import 'package:to_do_app/ui/screens/home_screen.dart';
import 'package:to_do_app/utils/helpers.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startAnimation();
  }

  startAnimation() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      replaceScreen(context, const HomeScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBody: true,
      body: Column(
        children: [
          Flexible(
            flex: 1,
            child: Image.asset(
              height: 500,
              'assets/waven_do.png',
              fit: BoxFit.cover,
            ),
          ),
          WaveWidget(
            config: CustomConfig(
              colors: [
                Colors.blue[200] ?? Colors.blue,
                Colors.blue[300] ?? Colors.blue,
                Colors.blue[400] ?? Colors.blue,
                Colors.blue[500] ?? Colors.blue,
              ],
              durations: [6000, 5000, 4000, 3000],
              heightPercentages: [0.45, 0.47, 0.49, 0.51],
            ),
            size: Size(size.width, size.height / 2),
          ),
        ],
      ),
    );
  }
}
