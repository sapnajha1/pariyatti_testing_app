import 'package:flutter/material.dart';
import 'package:vimeo_video_player/vimeo_video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoId;

  const VideoPlayerScreen({required this.videoId, Key? key}) : super(key: key);

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late String videoUrl;

  @override
  void initState() {
    super.initState();
    videoUrl = 'https://player.vimeo.com/video/${widget.videoId}'; // Example of URL caching
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,

        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).colorScheme.onPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.file_upload_outlined, color: Theme.of(context).colorScheme.onPrimary),
            onPressed: () {
              // Implement download functionality here
            },
          ),
          IconButton(
            icon: Icon(Icons.bookmark_outline_outlined, color: Theme.of(context).colorScheme.onPrimary),
            onPressed: () {
              // Implement bookmark functionality here
            },
          ),
        ],
      ),      body: VimeoVideoPlayer(videoId: widget.videoId),
    );
  }
}



