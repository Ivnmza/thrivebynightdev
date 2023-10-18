import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ChewieItem extends StatefulWidget {
  const ChewieItem({super.key, required this.url, required this.title});
  final String url;
  final String title;

  @override
  State<ChewieItem> createState() => _ChewieItemState();
}

class _ChewieItemState extends State<ChewieItem> {
  late VideoPlayerController _ccontroller;
  late ChewieController _chewieController;
  int? bufferDelay;

  @override
  void initState() {
    super.initState();
    initializePlayer();
    _chewieController = ChewieController(
      videoPlayerController: _ccontroller,
      autoPlay: true,
      looping: true,
      progressIndicatorDelay:
          bufferDelay != null ? Duration(milliseconds: bufferDelay!) : null,
      subtitleBuilder: (context, dynamic subtitle) => Container(
        padding: const EdgeInsets.all(10.0),
        child: subtitle is InlineSpan
            ? RichText(
                text: subtitle,
              )
            : Text(
                subtitle.toString(),
                style: const TextStyle(color: Colors.black),
              ),
      ),
      hideControlsTimer: const Duration(seconds: 1),
    );
  }

    @override
  void dispose() {
    _ccontroller.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  Future<void> initializePlayer() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: _chewieController.videoPlayerController.value.isInitialized
              ? Chewie(
                  controller: _chewieController,
                )
              : const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text('Loading'),
                  ],
                ),
        ),
      ],
    );
  }
}