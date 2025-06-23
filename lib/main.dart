import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fvp/fvp.dart';
import 'package:fvp_test_mute/widgets/video_player_widget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isLinux) {
    // Register video decoder
    print('Registering video decoder VAAPI');
    registerWith(
      options: {
        'video.decoders': ['VAAPI'],
        'global': {'log': 'off'},
      },
    );
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int counter = 0;

  @override
  void initState() {
    super.initState();
    // Recreate state every 3 secs
    Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        counter = (counter + 1);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 700),
      switchInCurve: Curves.linear,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: Center(key: UniqueKey(), child: _buildContent()),
    );
  }

  Widget _buildContent() {
    return VideoPlayerWidget(
      key: UniqueKey(),
      muted: counter % 2 == 0, // Mute every second time
      src: 'assets/videos/big-buck-bunny-1080p-30sec.mp4',
      onCompleted: () {},
    );
  }
}
