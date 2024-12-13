// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// import 'package:flutter/material.dart';
// import 'package:patta/ui/screens/resources/video_ui.dart';
// import 'package:provider/provider.dart';
// import 'package:smooth_page_indicator/smooth_page_indicator.dart';
// import 'package:vimeo_player_flutter/vimeo_player_flutter.dart';
//
//
// class ResourcesScreen extends StatefulWidget {
//   @override
//   State<ResourcesScreen> createState() => _ResourcesScreenState();
// }
//
// class _ResourcesScreenState extends State<ResourcesScreen> {
//   int selectedIndex = 0;
//   final PageController _pageController = PageController();
//
//
//   void _onTabTapped(int index) {
//     // if (index==1){
//     //   Navigator.push(context, MaterialPageRoute(builder: (context) => VimeoVideoUI()));
//     // }
//     // else {
//
//     setState(() {
//       selectedIndex = index;
//     });
//     // }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//
//     return
//       DefaultTabController(
//           length: 2,
//           child: Scaffold(
//             backgroundColor: Colors.grey.shade200,
//
//
//             appBar: AppBar(
//               title: Container(
//                 width: double.infinity,
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         InkWell(
//                             child: Text("Old students?",
//                                 style: TextStyle(color: Colors.red,fontSize: 19))),
//                         Text("Resources",
//                             style: TextStyle(fontWeight: FontWeight.bold,fontSize: 19)),
//                         IconButton(
//                           onPressed: () {},
//                           icon: Icon(Icons.search, color: Colors.brown.shade300,size: 25,),
//                         ),
//                       ],
//                     ),
//                     Divider(color: Colors.black12, thickness: 2),                 ],
//                 ),
//               ),
//
//               bottom: TabBar(
//
//                 labelColor: Colors.black,
//                 unselectedLabelColor: Colors.black54,
//                 indicatorColor: Colors.red,
//                 splashFactory: NoSplash.splashFactory,
//                 tabs: [
//                   Tab(text: 'ALL'),
//                   // Tab(text: 'AUDIOS'),
//                   // Tab(text: 'BOOKS'),
//                   Tab(text: 'VIDEOS'),
//                 ],
//                 onTap: _onTabTapped,
//               ),
//
//             ),
//             body:
//
//
//
//
//
//             Column(
//               children: [
//                 Container(
//                     decoration: BoxDecoration(
//                         color: Colors.white,
//                         border: Border(
//                             bottom: BorderSide(
//                                 color: Colors.black12,
//                                 width: 1.0
//                             )
//                         )),
//                     child: Column(children: [
//                       Padding(
//                         padding: const EdgeInsets.only(
//                           top: 28.0,
//                         ),
//                         child: SizedBox(
//                           height: screenHeight * 0.30,
//                           child: PageView.builder(
//                             controller: _pageController,
//                             itemCount: 5,
//                             itemBuilder: (context, index) {
//                               return Container(
//                                 width: screenWidth * 0.5,
//                                 margin: EdgeInsets.symmetric(
//                                     horizontal: screenWidth * 0.025),
//                                 decoration: BoxDecoration(
//                                   color: Colors.blueAccent,
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//
//                                 child: Center(
//                                   child: Text('First List - Item $index',
//                                       style: TextStyle(color: Colors.white)),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ),
//
//                       Padding(
//                         padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
//                         child: SmoothPageIndicator(
//                           controller: _pageController,
//                           count: 5,
//                           effect: ScrollingDotsEffect(
//                               dotHeight: 8,
//                               dotWidth: 8,
//                               activeDotColor: Colors.red,
//                               activeDotScale: 1.0,
//                               dotColor: Colors.grey,
//                               spacing: 8.0),
//                         ),
//                       ),
//                     ])),
//
//                 Expanded(
//                   child: TabBarView(
//                     children: [
//                       buildTabContent(screenWidth, screenHeight,
//                           showSecondList: true, showThirdList: true), // All Tab
//                       buildTabContent(
//                         screenWidth,
//                         screenHeight,
//                       ), // Audios Tab
//                       buildTabContent(screenWidth, screenHeight), // Books Tab
//                       buildTabContent(screenWidth, screenHeight), // Videos Tab
//                     ],
//                   ),
//                 ),
//               ],
//             )
//           )
//       );
//
//   }
//
//
//
// Widget buildTabContent(double screenWidth, double screenHeight,
//     {bool showSecondList = false, bool showThirdList = false}) {
//   return SingleChildScrollView(
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (showSecondList) ...[
//           SizedBox(height: screenHeight * 0.02),
//           sectionHeader(screenWidth, "Popular Collection"),
//           SizedBox(
//             height: screenHeight * 0.11,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               itemCount: 5,
//               itemBuilder: (context, index) {
//                 return Container(
//                   width: screenWidth * 0.4,
//                   margin:
//                   EdgeInsets.symmetric(horizontal: screenWidth * 0.025),
//                   decoration: BoxDecoration(
//                     color: Colors.purple,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Center(child: Text("Second List - Item $index")),
//                 );
//               },
//             ),
//           ),
//         ],
//         if (showThirdList) ...[
//           SizedBox(height: screenHeight * 0.02),
//           sectionHeader(screenWidth, "On the Topic of"),
//           SizedBox(
//             height: screenHeight * 0.11,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               itemCount: 5,
//               itemBuilder: (context, index) {
//                 return Container(
//                   width: screenWidth * 0.4,
//                   margin:
//                   EdgeInsets.symmetric(horizontal: screenWidth * 0.025),
//                   decoration: BoxDecoration(
//                     color: Colors.deepPurple,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Center(child: Text("Third List - Topic $index")),
//                 );
//               },
//             ),
//           ),
//         ],
//       ],
//     ),
//   );
// }
//
// Widget sectionHeader(double screenWidth, String title) {
//   return Padding(
//     padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           title,
//           style: TextStyle(
//             fontSize: screenWidth * 0.045,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         TextButton(
//           onPressed: () {},
//           child: Text("See All", style: TextStyle(color: Colors.red)),
//         ),
//       ],
//     ),
//   );
// }
// }
//
//
//
//
//
//
//
//
//
//
