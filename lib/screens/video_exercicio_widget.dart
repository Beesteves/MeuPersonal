import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoExercicioWidget extends StatefulWidget {
  final String url;
  final Color textColor;

  const VideoExercicioWidget({
    super.key,
    required this.url,
    required this.textColor,
  });

  @override
  State<VideoExercicioWidget> createState() => _VideoExercicioWidgetState();
}

class _VideoExercicioWidgetState extends State<VideoExercicioWidget> {
  YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayer.convertUrlToId(widget.url);
    if (videoId != null) {
      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: widget.textColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            "Vídeo não disponível",
            style: TextStyle(color: widget.textColor),
          ),
        ),
      );
    }

    return YoutubePlayer(
      controller: _controller!,
      showVideoProgressIndicator: true,
      progressIndicatorColor: Colors.red,
    );
  }
}
