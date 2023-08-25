import 'package:cliveott/src/view/live/premium/premium_appbar.dart';
import 'package:cliveott/src/view/live/premium/premium_video.dart';
import 'package:cliveott/src/view/live/premium/premiumvideo_tv.dart';

import 'package:cliveott/utils/colors.dart';
import 'package:cliveott/utils/responsive.dart';

import 'package:cliveott/utils/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:is_tv/is_tv.dart';

class Premium extends StatefulWidget {
  const Premium({super.key});

  @override
  State<Premium> createState() => _PremiumState();
}

class _PremiumState extends State<Premium> with TickerProviderStateMixin {
  List tvname = [
    'Madha TV',
    'Neeyam TV',
    'Divayavani TV',
    'Captain TV',
    'Malaimurasu',
    'News 7',
    'Puthiyathalaimurai',
    'Sangamamam TV',
    'TV 5',
    'Deepam TV',
    'Polimer TV',
    'Malar TV',
    'Vasanth TV',
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
                            height: 5.0.hp,
                            // width: 48.0.wp,
                            fit: BoxFit.fill,
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
      spaceImg: ('assets/premium/1.jpg'),
      spaceName: 'Madha TV',
    ),
    GridItem(
      spaceImg: ('assets/premium/2.jpg'),
      spaceName: 'Neeyam TV',
    ),
    GridItem(
      spaceImg: ('assets/premium/3.jpg'),
      spaceName: 'Divyavani TV',
    ),
    GridItem(
      spaceImg: ('assets/premium/4.jpg'),
      spaceName: 'Captain TV',
    ),
    GridItem(
      spaceImg: ('assets/premium/5.jpg'),
      spaceName: 'Malai Murasu TV',
    ),
    GridItem(
      spaceImg: ('assets/premium/6.jpg'),
      spaceName: 'NEWS 7',
    ),
    GridItem(
      spaceImg: ('assets/premium/7.jpg'),
      spaceName: 'Pudhiyathalaimurai',
    ),
    GridItem(
      spaceImg: ('assets/premium/8.jpg'),
      spaceName: 'Sangamam TV',
    ),
    GridItem(
      spaceImg: ('assets/premium/9.jpg'),
      spaceName: 'TV 5',
    ),
    GridItem(
      spaceImg: ('assets/premium/10.jpg'),
      spaceName: 'Deepam TV',
    ),
    GridItem(
      spaceImg: ('assets/premium/11.jpg'),
      spaceName: 'Polimer TV',
    ),
    GridItem(
      spaceImg: ('assets/premium/12.jpg'),
      spaceName: 'Malar TV',
    ),
    GridItem(
      spaceImg: ('assets/premium/13.jpg'),
      spaceName: 'Vasanth TV',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
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
              Text('Premium Channels', style: toptitleStylebold),
            ],
          ),
        ),
        SizedBox(
          height: 10.0.h,
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
                    focusColor: Colors.amber.withOpacity(0.2),
                    onTap: () {
                      setState(() {
                        _isTV!
                            ? Get.to(PremiumTVVideo(
                                index: index,
                                name: tvname[index],
                              ))
                            : Get.to(PremiumVideo(
                                index: index,
                                name: tvname[index],
                              ));
                        //   Get.to(
                        //       PremiumAppBar(index: index, name: tvname[index]));
                        //   print('clickkkk');
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
