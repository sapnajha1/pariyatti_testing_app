import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:patta/ui/screens/resources/video_ui.dart';
import 'package:vimeo_player_flutter/vimeo_player_flutter.dart';

/// Video model to hold video details
class Video {
  final String id;
  final String title;
  final String thumbnailUrl;


  Video({required this.id, required this.title, required this.thumbnailUrl});

  factory Video.fromJson(Map<String, dynamic> json) {
    final embedUrl = json['uri'] as String;
    final videoId = Uri.parse(embedUrl).pathSegments.last;
    final title = json['name'] as String;
    final thumbnailUrl = json['picture_base_link'] as String;

    return Video(id: videoId, title: title, thumbnailUrl: thumbnailUrl );
  }
}

class ResourcesScreen extends StatefulWidget {
  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> {
  late Future<List<Video>> _videoList;
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return DefaultTabController(
      length: 1,
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          title: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    child: Text(
                      "Old students?",
                      style: TextStyle(color: Colors.red, fontSize: 19),
                    ),
                  ),
                  Text(
                    "Resources",
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
              Divider(color: Colors.black12, thickness: 2),
            ],
          ),
          bottom: TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black54,
            indicatorColor: Colors.red,
            splashFactory: NoSplash.splashFactory,
            tabs: [
              Tab(text: 'VIDEOS'),
            ],
            onTap: _onTabTapped,
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Top free this week",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                              builder: (_) => VimeoPlayerScreen(videoId: video.id),
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
                                  image: DecorationImage(
                                    image: NetworkImage(video.thumbnailUrl),
                                    fit: BoxFit.cover,
                                  ),
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
}

// class VimeoPlayerScreen extends StatelessWidget {
//   final String videoId;
//
//   const VimeoPlayerScreen({required this.videoId, Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back_ios),
//           onPressed: () => Navigator.pop(context),
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.file_upload_outlined),
//             onPressed: () {
//               // Implement download functionality here
//             },
//           ),
//           IconButton(
//             icon: Icon(Icons.bookmark_outline_outlined),
//             onPressed: () {
//               // Implement bookmark functionality here
//             },
//           ),
//         ],
//       ),      body: VimeoPlayer(videoId: '1011864064'),
//     );
//   }
// }



// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:patta/ui/screens/resources/video_ui.dart';
// import 'package:vimeo_player_flutter/vimeo_player_flutter.dart';
//
// class ResourcesScreen extends StatefulWidget {
//   @override
//   State<ResourcesScreen> createState() => _ResourcesScreenState();
// }
//
// class _ResourcesScreenState extends State<ResourcesScreen> {
//   int selectedIndex = 0;
//   final PageController _pageController = PageController();
//   late Future<List<String>> _videoList;
//
//   @override
//   void initState() {
//     super.initState();
//     _videoList = fetchVideos();
//   }
//
//   Future<List<String>> fetchVideos() async {
//     final url = Uri.parse('https://kosa-staging.pariyatti.app/api/v1/library/videos.json');
//     final response = await http.get(url);
//
//     if (response.statusCode == 200) {
//       final List<dynamic> json = jsonDecode(response.body);
//
//       final videoIds = json.map<String>((video) {
//         final embedUrl = video['uri'] as String;
//         final videoId = Uri.parse(embedUrl).pathSegments.last;
//         final videoTitle = video['name'] as String;
//         final VideoTitle = Uri.parse(videoTitle);
//
//         return videoId;
//       }).toList();
//
//       return videoIds;
//     } else {
//       throw Exception('Failed to load videos');
//     }
//   }
//
//   void _onTabTapped(int index) {
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
//         backgroundColor: Colors.grey.shade200,
//         appBar: AppBar(
//           title: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   InkWell(
//                     child: Text(
//                       "Old students?",
//                       style: TextStyle(color: Colors.red, fontSize: 19),
//                     ),
//                   ),
//                   Text(
//                     "Resources",
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
//               Divider(color: Colors.black12, thickness: 2),
//             ],
//           ),
//           bottom: TabBar(
//             labelColor: Colors.black,
//             unselectedLabelColor: Colors.black54,
//             indicatorColor: Colors.red,
//             splashFactory: NoSplash.splashFactory,
//             tabs: [
//               Tab(text: 'VIDEOS'),
//             ],
//             onTap: _onTabTapped,
//           ),
//         ),
//         body: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Section Title: "Top free this week"
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Text(
//                 "Top free this week",
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//             ),
//             // Horizontal List of Videos
//             Expanded(
//               child: FutureBuilder<List<String>>(
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
//                   return Column(
//                     children: [
//                       Container(
//                         height: 200,
//                         child: ListView.builder(
//                           itemCount: videos.length,
//                           scrollDirection: Axis.horizontal,
//                           itemBuilder: (context, index) {
//                             final videoUrl = videos[index];
//
//                             return GestureDetector(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (_) => VimeoPlayerScreen(videoId: videoUrl),
//                                   ),
//                                 );
//                               },
//                               child: Container(
//                                 margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//                                 width: screenWidth * 0.6, // 60% of screen width
//                                 decoration: BoxDecoration(
//                                   color: Colors.red[200],
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                                 child:
//
//                                   Center(child: Text('Hello'),)
//
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//
//                       // Grey Divider
//                       Divider(
//                         color: Colors.grey,
//                         thickness: 1,
//                         indent: 16,
//                         endIndent: 16,
//                       ),
//                     ],
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class VimeoPlayerScreen extends StatelessWidget {
//   final String videoId;
//
//   const VimeoPlayerScreen({required this.videoId, Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Vimeo Player')),
//       body: VimeoPlayer(videoId: '1011864064'),
//     );
//   }
// }
//
//
// // import 'dart:convert';
// // import 'package:http/http.dart' as http;
// //
// // import 'package:flutter/material.dart';
// // import 'package:patta/ui/screens/resources/video_ui.dart';
// // import 'package:provider/provider.dart';
// // import 'package:smooth_page_indicator/smooth_page_indicator.dart';
// // import 'package:vimeo_player_flutter/vimeo_player_flutter.dart';
// //
// //
// // class ResourcesScreen extends StatefulWidget {
// //   @override
// //   State<ResourcesScreen> createState() => _ResourcesScreenState();
// // }
// //
// // class _ResourcesScreenState extends State<ResourcesScreen> {
// //   int selectedIndex = 0;
// //   final PageController _pageController = PageController();
// //   late Future<List<String>> _videoList;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _videoList = fetchVideos();
// //   }
// //
// //   Future<List<String>> fetchVideos() async {
// //     final url = Uri.parse('https://kosa-staging.pariyatti.app/api/v1/library/videos.json');
// //     final response = await http.get(url);
// //
// //     if (response.statusCode == 200) {
// //       final List<dynamic> json = jsonDecode(response.body);
// //
// //       final videoIds = json.map<String>((video) {
// //         final embedUrl = video['uri'] as String;
// //         final videoId = Uri.parse(embedUrl).pathSegments.last;
// //         print('Extracted video ID: $videoId'); // Debugging log
// //         return videoId;
// //       }).toList();
// //
// //       return videoIds;
// //
// //
// //       // Return a list of `player_embed_url` only
// //       // return json.map<String>((video) => video['player_embed_url'] as String).toList();
// //       // final videoId = Uri.parse(embedUrl).pathSegments.last;
// //       // return videoId;
// //     } else {
// //       throw Exception('Failed to load videos');
// //     }
// //   }
// //
// //   void _onTabTapped(int index) {
// //       setState(() {
// //         selectedIndex = index;
// //       });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //
// //     final screenWidth = MediaQuery.of(context).size.width;
// //     final screenHeight = MediaQuery.of(context).size.height;
// //
// //     return
// //        DefaultTabController(
// //           length: 2,
// //           child: Scaffold(
// //               backgroundColor: Colors.grey.shade200,
// //
// //
// //               appBar: AppBar(
// //                 title: Container(
// //                   width: double.infinity,
// //                   child: Column(
// //                     children: [
// //                       Row(
// //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                         children: [
// //                           InkWell(
// //                               child: Text("Old students?",
// //                                   style: TextStyle(color: Colors.red,fontSize: 19))),
// //                           Text("Resources",
// //                               style: TextStyle(fontWeight: FontWeight.bold,fontSize: 19)),
// //                           IconButton(
// //                             onPressed: () {},
// //                             icon: Icon(Icons.search, color: Colors.brown.shade300,size: 25,),
// //                           ),
// //                         ],
// //                       ),
// //                       Divider(color: Colors.black12, thickness: 2),                 ],
// //                   ),
// //                 ),
// //
// //                   bottom: TabBar(
// //
// //                               labelColor: Colors.black,
// //                               unselectedLabelColor: Colors.black54,
// //                               indicatorColor: Colors.red,
// //                               splashFactory: NoSplash.splashFactory,
// //                               tabs: [
// //                                 // Tab(text: 'AUDIOS'),
// //                                 // Tab(text: 'BOOKS'),
// //                                 Tab(text: 'VIDEOS'),
// //                               ],
// //                               onTap: _onTabTapped,
// //                             ),
// //
// //               ),
// //               body: FutureBuilder<List<String>>(
// //                 future: _videoList,
// //                 builder: (context, snapshot) {
// //                   if (snapshot.connectionState == ConnectionState.waiting) {
// //                     return const Center(child: CircularProgressIndicator());
// //                   } else if (snapshot.hasError) {
// //                     return Center(child: Text('Error: ${snapshot.error}'));
// //                   } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
// //                     return const Center(child: Text('No videos available'));
// //                   }
// //
// //                   final videos = snapshot.data!;
// //                   return Container(color: Colors.red,
// //                     height: 250,
// //                     width: 700,
// //                     child: ListView.builder(
// //                       itemCount: videos.length,
// //                       scrollDirection: Axis.horizontal,
// //                       itemBuilder: (context, index) {
// //                         final videoUrl = videos[index];
// //                         return GestureDetector(
// //                           onTap: () {
// //                             Navigator.push(
// //                               context,
// //                               MaterialPageRoute(
// //                                 builder: (_) => VimeoPlayerScreen(videoId: videoUrl),
// //                               ),
// //                             );
// //                           },
// //                           child: Container(
// //                             margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
// //                             // height: 5,
// //                             // color: Colors.grey[200],
// //                             decoration: BoxDecoration(
// //                               color: Colors.yellow[200],
// //                               borderRadius: BorderRadius.circular(30), // 30% rounded radius
// //                             ),
// //                             child: Center(
// //                               child: Text(
// //                                 'Play Video ${index + 1}',
// //                                 style: const TextStyle(fontSize: 18, color: Colors.black),
// //                               ),
// //                             ),
// //                           ),
// //                         );
// //                       },
// //                     ),
// //                   );
// //                 },
// //               ),
// //           )
// //        );
// //   }
// // }
// //
// //
// //
// // class VimeoPlayerScreen extends StatelessWidget {
// //   final String videoId;
// //
// //   const VimeoPlayerScreen({required this.videoId, Key? key}) : super(key: key);
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: const Text('Vimeo Player')),
// //       body: VimeoPlayer(videoId: '1011864064'),
// //
// //       // onError: (error) {
// //       //   print('Error loading video: $error'); // Log errors
// //       // },
// //     );
// //   }
// // }
// //
// //
// //
// //
// //
// //
// //
// //
// //
