import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:patta/app/app_themes.dart';
import 'package:patta/ui/screens/library/VideoScreen.dart';
import 'package:patta/app/I18n.dart';



/// Video model to hold video details
class Video {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String videoUrl;



  Video({required this.id, required this.title, required this.thumbnailUrl, required this.videoUrl});

  factory Video.fromJson(Map<String, dynamic> json) {
    final embedUrl = json['uri'] as String;
    final videoId = Uri.parse(embedUrl).pathSegments.last;
    final title = json['name'] as String;
    final thumbnailUrl = json['picture_base_link'] as String;
    final videoUrl = json['player_embed_url'] as String;

    return Video(id: videoId, title: title, thumbnailUrl: thumbnailUrl , videoUrl: videoUrl);
  }

  Future<void> checkIfImageIsCached(String imageUrl) async {
    final cacheManager = DefaultCacheManager();
    final fileInfo = await cacheManager.getFileFromCache(imageUrl);

    if (fileInfo != null) {
      print('Image is cached at: ${fileInfo.file.path}');
    } else {
      print('Image is not cached.');
    }
  }



  // Future<void> debugImageCache(String imageUrl) async {
  //   final cacheManager = DefaultCacheManager();
  //   final fileInfo = await cacheManager.getFileFromCache(imageUrl);
  //
  //   if (fileInfo != null) {
  //     print('Image is cached: ${fileInfo.file.path}');
  //   } else {
  //     print('Image is not cached.');
  //   }
  // }
}

class LibraryScreen extends StatefulWidget {


  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  late Future<List<Video>> _videoList;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return DefaultTabController(
      length: 1,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,

          title: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    child: Text(I18n.get(
                        "Old students?"),
                      style: TextStyle(color: Colors.red, fontSize: 19),
                    ),
                  ),
                  Text(I18n.get(
                      "Resources"),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.search,
                      color: Colors.brown.shade300,
                      size: 25,
                    ),
                  ),
                ],
              ),
              Divider(color: Theme.of(context).colorScheme.onBackground
                  , thickness: 1),
            ],
          ),
          bottom: TabBar(
            labelColor: Theme.of(context).colorScheme.onPrimary,
            unselectedLabelColor: Colors.black54,
            indicatorColor: Colors.red,
            splashFactory: NoSplash.splashFactory,
            tabs: [
              Tab(text:I18n.get('VIDEOS'),),
            ],
            onTap: _onTabTapped,
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(I18n.get(
                  "Top free this week"),
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimary),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Video>>(
                future: _videoList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No videos available'));
                  }

                  final videos = snapshot.data!;
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: videos.length,
                    itemBuilder: (context, index) {
                      final video = videos[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => VideoPlayerScreen(videoId: video.id,),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          width: screenWidth * 0.6, // 60% of screen width
                          child: Column(
                            children: [
                              // Video Thumbnail Placeholder
                              Container(
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  // image: DecorationImage(
                                  //   image:
                                  //    CachedNetworkImageProvider(video.thumbnailUrl,   cacheManager: DefaultCacheManager(),
                                  //   ),
                                  //   fit: BoxFit.cover,
                                  // ),
                                ),
                          child: CachedNetworkImage(
                            imageUrl: video.thumbnailUrl,
                            // cacheManager: CustomCacheManager.instance,
                            placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                            fit: BoxFit.cover,
                          ),
                              ),
                              // Video Title
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  video.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                                ),
                              ),

                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),

            ),

          ],
        ),
      ),
    );
  }

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _videoList = fetchVideos(); // Ensure the type matches here
  }

  /// Fetches videos from the API
  Future<List<Video>> fetchVideos() async {
    final url = Uri.parse('https://kosa-staging.pariyatti.app/api/v1/library/videos.json');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map<Video>((video) => Video.fromJson(video)).toList();
    } else {
      throw Exception('Failed to load videos');
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}




// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:patta/app/app_themes.dart';
// import 'package:patta/ui/screens/library/VideoScreen.dart';
// import 'package:patta/app/I18n.dart';
//
//
//
// /// Video model to hold video details
// class Video {
//   final String id;
//   final String title;
//   final String thumbnailUrl;
//   final String videoUrl;
//
//
//
//   Video({required this.id, required this.title, required this.thumbnailUrl, required this.videoUrl});
//
//   factory Video.fromJson(Map<String, dynamic> json) {
//     final embedUrl = json['uri'] as String;
//     final videoId = Uri.parse(embedUrl).pathSegments.last;
//     final title = json['name'] as String;
//     final thumbnailUrl = json['picture_base_link'] as String;
//     final videoUrl = json['player_embed_url'] as String;
//
//     return Video(id: videoId, title: title, thumbnailUrl: thumbnailUrl , videoUrl: videoUrl);
//   }
// }
//
// class LibraryScreen extends StatefulWidget {
//   @override
//   State<LibraryScreen> createState() => _LibraryScreenState();
// }
//
// class _LibraryScreenState extends State<LibraryScreen> {
//   late Future<List<Video>> _videoList;
//   int selectedIndex = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _videoList = fetchVideos(); // Ensure the type matches here
//   }
//
//   /// Fetches videos from the API
//   Future<List<Video>> fetchVideos() async {
//     final url = Uri.parse('https://kosa-staging.pariyatti.app/api/v1/library/videos.json');
//     final response = await http.get(url);
//
//     if (response.statusCode == 200) {
//       final List<dynamic> jsonData = jsonDecode(response.body);
//       return jsonData.map<Video>((video) => Video.fromJson(video)).toList();
//     } else {
//       throw Exception('Failed to load videos');
//     }
//   }
//
//     void _onTabTapped(int index) {
//     setState(() {
//       selectedIndex = index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     return DefaultTabController(
//       length: 1,
//       child: Scaffold(
//         backgroundColor: Theme.of(context).colorScheme.background,
//         appBar: AppBar(
//           backgroundColor: Theme.of(context).colorScheme.background,
//
//           title: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   InkWell(
//                     child: Text(I18n.get(
//                       "Old students?"),
//                       style: TextStyle(color: Colors.red, fontSize: 19),
//                     ),
//                   ),
//                   Text(I18n.get(
//                     "Resources"),
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
//                   ),
//                   IconButton(
//                     onPressed: () {},
//                     icon: Icon(
//                       Icons.search,
//                       color: Colors.brown.shade300,
//                       size: 25,
//                     ),
//                   ),
//                 ],
//               ),
//               Divider(color: Theme.of(context).colorScheme.onBackground
//             , thickness: 1),
//             ],
//           ),
//           bottom: TabBar(
//             labelColor: Theme.of(context).colorScheme.onPrimary,
//             unselectedLabelColor: Colors.black54,
//             indicatorColor: Colors.red,
//             splashFactory: NoSplash.splashFactory,
//             tabs: [
//               Tab(text:I18n.get('VIDEOS'),),
//             ],
//             onTap: _onTabTapped,
//           ),
//         ),
//         body: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Text(I18n.get(
//                 "Top free this week"),
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimary),
//               ),
//             ),
//             Expanded(
//               child: FutureBuilder<List<Video>>(
//                 future: _videoList,
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(child: CircularProgressIndicator());
//                   } else if (snapshot.hasError) {
//                     return Center(child: Text('Error: ${snapshot.error}'));
//                   } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                     return const Center(child: Text('No videos available'));
//                   }
//
//                   final videos = snapshot.data!;
//                   return ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: videos.length,
//                     itemBuilder: (context, index) {
//                       final video = videos[index];
//
//                       return GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => VideoPlayerScreen(videoId: video.id,),
//                             ),
//                           );
//                         },
//                         child: Container(
//                           margin: const EdgeInsets.symmetric(horizontal: 10),
//                           width: screenWidth * 0.6, // 60% of screen width
//                           child: Column(
//                             children: [
//                               // Video Thumbnail Placeholder
//                               Container(
//                                 height: 150,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(10),
//                                   image: DecorationImage(
//                                     image: NetworkImage(video.thumbnailUrl),
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                               ),
//                               // Video Title
//                               Padding(
//                                 padding: const EdgeInsets.only(top: 8.0),
//                                 child: Text(
//                                   video.title,
//                                   maxLines: 2,
//                                   overflow: TextOverflow.ellipsis,
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
//                                 ),
//                               ),
//
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//
//             ),
//
//           ],
//         ),
//       ),
//     );
//   }
// }
//
