import 'package:flutter/material.dart';
import 'package:vimeo_video_player/vimeo_video_player.dart';

class VimeoPlayerScreen extends StatelessWidget {
  final String videoId;

  const VimeoPlayerScreen({required this.videoId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.file_upload_outlined),
            onPressed: () {
              // Implement download functionality here
            },
          ),
          IconButton(
            icon: Icon(Icons.bookmark_outline_outlined),
            onPressed: () {
              // Implement bookmark functionality here
            },
          ),
        ],
      ),      body: VimeoVideoPlayer(videoId: videoId),
    );
  }
}



