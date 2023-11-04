import 'package:flutter/material.dart';
import 'package:to_do_app/ui/widgets/switch_widget.dart';
import 'package:to_do_app/utils/constants.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class Header extends StatefulWidget {
  const Header({super.key});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Stack(
      children: [
        WaveWidget(
          config: CustomConfig(
            colors: [
              Colors.blueAccent[100] ?? Colors.blueAccent,
              Colors.blueAccent[200] ?? Colors.blueAccent,
              Colors.blueAccent[300] ?? Colors.blueAccent,
              Colors.blueAccent[400] ?? Colors.blueAccent,
            ],
            durations: [32000, 21000, 18000, 5000],
            heightPercentages: [0.28, 0.30, 0.32, 0.34],
          ),
          size: Size(size.width, size.height * 0.5),
        ),
        Container(
          color: Colors.transparent,
          width: size.width,
          height: size.height,
          padding: EdgeInsets.symmetric(horizontal: kPadding(context)),
          child: const Align(
            alignment: Alignment(-1, 0.7),
            child: Row(
              children: [
                Text("Bem vindo ao WavenDo",
                    style: TextStyle(fontSize: 28, color: Colors.white)),
                ThemeButton(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
