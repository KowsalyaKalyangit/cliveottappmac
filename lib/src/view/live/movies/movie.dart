import 'package:cliveott/src/view/live/movies/movie_mobile.dart';
import 'package:cliveott/src/view/live/movies/movies_video.dart';
import 'package:cliveott/utils/colors.dart';

import 'package:cliveott/utils/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:is_tv/is_tv.dart';

import '../../dashboard/clive_videos.dart';

class MoviesPage extends StatefulWidget {
  const MoviesPage({super.key});

  @override
  State<MoviesPage> createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> with TickerProviderStateMixin {
  List tvname = [
    'Enter 10',
    'Movie Classic',
    'Movie Opera',
    'B4U Kadak',
    'B4U Movies'
  ];
  var selectedindex = 0;
  bool isHover = false;
  bool? _isTV = false;
  final _isTVPlugin = IsTV();

  Future<void> initPlatformState() async {
    bool? isTV;

    try {
      isTV = await _isTVPlugin.check() ?? false;
    } on PlatformException {
      isTV = false;
    }

    if (!mounted) return;

    setState(() {
      _isTV = isTV ?? false;
    });
  }

  Widget gridCard({required GridItem card}) => Container(
          child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: InkWell(
                      focusColor: Colors.blue,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.asset(
                            card.spaceImg,
                          )))),
              SizedBox(
                height: 5.0.h,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Text(
                      card.spaceName,
                      style: toptitleStylebold,
                    ),
                  )
                ],
              ),
            ]),
      ));
  @override
  void initState() {
    initPlatformState();
    super.initState();
  }

  List<GridItem> card = [
    GridItem(
      spaceImg: ('assets/premium/54.jpg'),
      spaceName: 'Enterr 10',
    ),
    GridItem(
      spaceImg: ('assets/premium/55.jpg'),
      spaceName: 'B4U Movies',
    ),
    GridItem(
      spaceImg: ('assets/premium/57.jpg'),
      spaceName: 'B4U Kadak',
    ),
    GridItem(
      spaceImg: ('assets/premium/56.jpg'),
      spaceName: 'Movie Opera',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1000.0.h,
      width: 1000.w,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/loginbg.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(
                    height: 18.0.h,
                    width: 1.0.w,
                    color: Colors.red[900],
                  ),
                  SizedBox(
                    width: 5.0.w,
                  ),
                  Text('Hindi Movies', style: toptitleStylebold),
                ],
              ),
            ),
            Container(
              height: 150.h,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                // physics: NeverScrollableScrollPhysics(),
                itemCount: card.length,
                itemBuilder: (BuildContext context, index) {
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                        // autofocus: true,
                        focusColor: Colors.blue.withOpacity(0.4),
                        onTap: () {
                          setState(() {
                            _isTV!
                                ? Get.to(MovieVideo(
                                    index: index,
                                    name: tvname[index],
                                  ))
                                : Get.to(MovieMobile(
                                    index: index,
                                    name: tvname[index],
                                  ));
                            print('clickkkk');
                          });
                        },
                        child: gridCard(
                          card: card[index],
                        )),
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

//       body: SingleChildScrollView(
//         child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(
//                 height: 1.0.hp,
//               ),
//               Container(
//                 height: 100.0.hp,
//                 width: 100.0.wp,
//                 child: GridView.builder(
//                   itemCount: images.length,
//                   itemBuilder: (context, index) {
//                     return (
//                       onTap: () {
//                         Get.to(CliveVideos(
//                           index: index,
//                           name: tvname[index],
//                         ));
//                       },
//                       child: Column(
//                         children: [
//                           Card(
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(20.0),
//                               ),
//                               child: Container(
//                                 height: 20.0.hp,
//                                 width: 42.0.wp,
//                                 child: Image.asset(
//                                   images[index],
//                                 ),
//                               )),
//                           FittedBox(
//                             child: Text(
//                               tvname[index],
//                               style: subtitleStyle,
//                             ),
//                           )
//                         ],
//                       ),
//                     );
//                   },
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2,
//                       childAspectRatio: 2 / 2,
//                       mainAxisSpacing: 20),
//                 ),
//               ),
//             ]),
//       ),
//     );
//   }
// }

class GridItem {
  final String spaceImg;
  final String spaceName;

  const GridItem({
    required this.spaceImg,
    required this.spaceName,
  });
}
