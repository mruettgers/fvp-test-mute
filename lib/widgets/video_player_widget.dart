import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String src;
  final bool muted;
  final Function onCompleted;

  const VideoPlayerWidget({
    super.key,
    required this.src,
    this.muted = false,
    required this.onCompleted,
  });

  @override
  VideoPlayerWidgetState createState() => VideoPlayerWidgetState();
}

class VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late final VideoPlayerController _videoPlayerController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() async {
    print('Initializing video player (key: ${widget.key})');
    _isInitialized = false;

    _videoPlayerController = VideoPlayerController.asset(widget.src);

    _videoPlayerController.initialize().then((_) async {
      _videoPlayerController.addListener(() {
        if (_isInitialized) {
          if (_videoPlayerController.value.isCompleted &&
              _videoPlayerController.value.position >=
                  _videoPlayerController.value.duration) {
            Future.delayed(const Duration(milliseconds: 1500), () {
              widget.onCompleted();
            });
          }
        }
      });
      setState(() {
        _isInitialized = true;
      });
      if (widget.muted) {
        print('Muting video player (key: ${widget.key})');
        await _videoPlayerController.setVolume(0);
      }
      await _videoPlayerController.play();
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    print('VideoPlayerWidget disposed (key: ${widget.key})');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return !_isInitialized
        ? const Center(
          key: ValueKey('loading'),
          child: CircularProgressIndicator(),
        )
        : AspectRatio(
          key: ValueKey('video'),
          aspectRatio: _videoPlayerController.value.aspectRatio,
          child: VideoPlayer(_videoPlayerController),
        );
  }
}
