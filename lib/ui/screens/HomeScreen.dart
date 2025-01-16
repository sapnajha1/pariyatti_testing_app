import 'package:flutter/material.dart';
import 'package:patta/app/I18n.dart';
import 'package:patta/ui/common/pariyatti_icons.dart';
import 'package:patta/ui/common/slivered_view.dart';
import 'package:patta/ui/screens/account/AccountScreen.dart';
import 'package:patta/ui/screens/donate/DonateScreen.dart';
import 'package:patta/ui/screens/resources/ResourcesScreen.dart';
import 'package:patta/ui/screens/today/TodayScreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    SliveredView(
      title: I18n.get("today"),
      body: TodayScreen(),
    ),
    AccountScreen(() {}),
    SliveredView(
      title: I18n.get("donate"),
      body: DonateScreen(),
    ),
    ResourcesScreen(),
  ];

  // final List<String> _titles = [
  //   I18n.get("today"),
  //   I18n.get("account"),
  //   I18n.get("donate"),
  //   I18n.get("library"),
  // ];

  // @override
  // void initState() {
  //   super.initState();
  //   _fetchAndCacheThumbnails();
  // }

  // Future<void> _fetchAndCacheThumbnails() async {
  //   final url = 'https://kosa-staging.pariyatti.app/api/v1/library/videos.json';
  //   try {
  //     final response = await http.get(Uri.parse(url));
  //     if (response.statusCode == 200) {
  //       final List<dynamic> videos = json.decode(response.body)['data'];
  //       for (var video in videos) {
  //         final thumbnailUrl = video['thumbnail'];
  //         if (thumbnailUrl != null) {
  //           precacheImage(CachedNetworkImageProvider(thumbnailUrl), context);
  //         }
  //       }
  //     } else {
  //       print('Failed to load thumbnails: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error fetching thumbnails: $e');
  //   }
  // }


  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      // appBar: AppBar(
      //   title: Text(
      //     _titles[_currentIndex],
      //     style: Theme.of(context).textTheme.titleLarge,
      //   ),
      //   backgroundColor: Theme.of(context).colorScheme.primary,
      // ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Theme.of(context).colorScheme.surface,
        fixedColor: Theme.of(context).colorScheme.inversePrimary,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              PariyattiIcons.get(IconName.today),
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            activeIcon: Icon(
              PariyattiIcons.get(IconName.today),
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            label: I18n.get("today"),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              PariyattiIcons.get(IconName.person),
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            activeIcon: Icon(
              PariyattiIcons.get(IconName.person),
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            label: I18n.get("account"),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.volunteer_activism,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            activeIcon: Icon(
              Icons.volunteer_activism,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            label: I18n.get("donate"),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.video_library_rounded,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            activeIcon: Icon(
              Icons.video_library_rounded,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            label: I18n.get("library"),
          ),
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:patta/app/I18n.dart';
// import 'package:patta/ui/common/pariyatti_icons.dart';
// import 'package:patta/ui/common/slivered_view.dart';
// import 'package:patta/ui/screens/account/AccountScreen.dart';
// import 'package:patta/ui/screens/donate/DonateScreen.dart';
// import 'package:patta/ui/screens/resources/ResourcesScreen.dart';
// import 'package:patta/ui/screens/today/TodayScreen.dart';
//
// enum HomeScreenTab { TODAY, ACCOUNT, DONATE , LIBRARY }
// // RESOURCES
// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   HomeScreenTab _tab = HomeScreenTab.TODAY;
//
//   void rebuild() {
//     setState(() => {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     int bottomNavigationBarIndex ;
//     String titleText;
//     Widget bodyWidget;
//     switch (_tab) {
//       case HomeScreenTab.TODAY:
//         bottomNavigationBarIndex = 0;
//         titleText = '${I18n.get("today")}';
//         bodyWidget = SliveredView(
//           title: titleText,
//           body: TodayScreen(),
//         );
//         break;
//       case HomeScreenTab.ACCOUNT:
//         bottomNavigationBarIndex = 1;
//         titleText = '${I18n.get("account")}';
//         bodyWidget = SliveredView(
//           title: titleText,
//           body: AccountScreen(rebuild),
//         );
//         break;
//       case HomeScreenTab.DONATE:
//         bottomNavigationBarIndex = 2;
//         titleText = '${I18n.get("donate")}';
//         bodyWidget = SliveredView(
//           title: titleText,
//           body: DonateScreen(),
//         );
//         break;
//
//         //Tab for resources or Library...
//
//       case HomeScreenTab.LIBRARY:
//         bottomNavigationBarIndex = 3;
//         titleText = '${I18n.get("library")} ';
//         bodyWidget = ResourcesScreen();
//         break;
//
//       // case HomeScreenTab.RESOURCES:
//       //   bottomNavigationBarIndex = 3;
//       //   titleText = '${I18n.get("resources")} ';
//       //   bodyWidget = SliveredView(
//       //     title: titleText,
//       //     body: ResourcesScreen(),
//       //   );
//       //   break;
//     }
//
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.surface,
//       body: bodyWidget,
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: bottomNavigationBarIndex,
//         backgroundColor: Theme.of(context).colorScheme.surface,
//         fixedColor: Theme.of(context).colorScheme.inversePrimary,
//         type: BottomNavigationBarType.fixed,
//         items: <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(
//               PariyattiIcons.get(IconName.today),
//               color: Theme.of(context).colorScheme.onPrimary,
//             ),
//             activeIcon: Icon(
//               PariyattiIcons.get(IconName.today),
//               color: Theme.of(context).colorScheme.inversePrimary,
//             ),
//             label: I18n.get("today")
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(
//               PariyattiIcons.get(IconName.person),
//               color: Theme.of(context).colorScheme.onPrimary,
//             ),
//             activeIcon: Icon(
//               PariyattiIcons.get(IconName.person),
//               color: Theme.of(context).colorScheme.inversePrimary,
//             ),
//             label: I18n.get("account")
//           ),
//           BottomNavigationBarItem(
//               icon: Icon(
//                 Icons.volunteer_activism,
//                 color: Theme.of(context).colorScheme.onPrimary,
//               ),
//               activeIcon: Icon(
//                 Icons.volunteer_activism,
//                 color: Theme.of(context).colorScheme.inversePrimary,
//               ),
//               label: I18n.get("donate")
//           ),
//
//           BottomNavigationBarItem(
//               icon: Icon(
//                 Icons.video_library_rounded,
//                 color: Theme.of(context).colorScheme.onPrimary,
//               ),
//               activeIcon: Icon(
//                 Icons.video_library_rounded,
//                 color: Theme.of(context).colorScheme.inversePrimary,
//               ),
//               label: I18n.get("library")
//           ),
//         ],
//         onTap: (int tappedItemIndex) {
//           this.setState(() {
//             this._tab = HomeScreenTab.values[tappedItemIndex];
//           });
//         },
//       ),
//     );
//   }
//
// }
