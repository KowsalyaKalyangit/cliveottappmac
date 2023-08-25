import 'package:cliveott/src/controller/home_controller.dart';
import 'package:cliveott/src/controller/login_controller.dart';
import 'package:cliveott/src/view/dashboard/home_section_four.dart';
import 'package:cliveott/src/view/dashboard/home_section_three.dart';
import 'package:cliveott/src/view/dashboard/popular.dart';
import 'package:cliveott/src/view/dashboard/homepage.dart';
import 'package:cliveott/src/view/dashboard/userProfile.dart';
import 'package:cliveott/src/view/live/live_channels_only.dart';

import 'package:cliveott/src/view/live/movies/movie.dart';

import 'package:cliveott/src/view/live/news_page.dart';

import 'package:cliveott/utils/common_function/bottom_nav_bar.dart';
import 'package:cliveott/utils/common_function/helper_class.dart';
import 'package:cliveott/utils/responsive.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:is_tv/is_tv.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/colors.dart';

import '../../../utils/common_function/constants.dart';
import '../../../utils/textstyles.dart';
import '../../controller/force_update_controller.dart';
import '../../controller/my_watchlist_controller.dart';
import '../../controller/user_profile_controller.dart';
import '../dashboard/sliding_banner.dart';

import '../live/livetv_category/livetv_category.dart';
import '../live/premium/premium.dart';

import '../login/login_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';

import 'edit_profile.dart';
import 'image_slider.dart';
import 'latest_page.dart';
import 'mywatchlist.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeController homeController = Get.put(HomeController());
  GetProfileController getProfileController = Get.put(GetProfileController());
  double? _progress;
  var url1 =
      'https://templates.cherritech.us/cherri-construction-template/assets/apk/app-release.apk';
  ForceUpdate forceUpdatecontroller = Get.put(ForceUpdate());
  String? _version;
  String? _buildNumber;
  String? _buildSignature;
  String? _appName;
  String? _packageName;
  String? _installerStore;
  _launchURL() async {
    final Uri url = Uri.parse(
        'https://templates.cherritech.us/cherri-construction-template/assets/apk/app-release.apk');
    if (!await launchUrl(url)) {
      print(url);
      throw Exception('Could not launch $url');
    }
  }

  int _currentIndex = 0;
  final List<Map<String, Widget>> _pages = [
    {
      'page': const HomePage(),
    },
    {
      'page': const LiveChannels(),
    },
    // {
    //   'page': const DetailsPage(),
    // },
    {
      'page': const MoviesPage(),
    },
  ];
  MyWatchListController myWatchListController =
      Get.put(MyWatchListController());

  @override
  void initState() {
    //forceUpdatecontroller.getGameController();
    homeController.homeController();
    getProfileController.userController();
    // myWatchListController.mywatchlistController();
    super.initState();
    initPlatformState();
    // _getAppVersion();
  }

  bool? _isTV = false;
  final _isTVPlugin = IsTV();

  Future<void> initPlatformState() async {
    bool? isTV;
    SharedPreferences prefs = await SharedPreferences.getInstance();
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

  showdialogFunc() {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          "Update Clive OTT?",
          style: heading,
        ),
        content: Text(
          '''Clive recommends that you update to the latest version. You can keep using this app using this app while downloading the update''',
          style: subcategorystyle,
        ),
        actions: <Widget>[
          _progress != null
              ? const CircularProgressIndicator()
              : InkWell(
                  onTap: () {
                    FileDownloader.downloadFile(
                        url: url1.trim(),
                        onProgress: (name, progress) {
                          setState(() {
                            _progress = progress;
                          });
                        },
                        onDownloadCompleted: (value) {
                          print('path  $value ');
                          setState(() {
                            _progress = null;
                          });
                        });
                  },
                  child: Container(
                      height: 40,
                      width: 85,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Color(0xff01875f)),
                      child: Center(
                          child: Text(
                        'update',
                        style: categorytext,
                      ))),
                )
        ],
      ),
    );
  }

  void _getAppVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();

    final version = packageInfo.version;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var version1 = sharedPreferences.getString(Constants.version);
    // final buildNumber = packageInfo.buildNumber;
    // final buildSignature = packageInfo.buildSignature;
    final appName = packageInfo.appName;
    // final packageName = packageInfo.packageName;
    // final installerStore = packageInfo.installerStore;

    setState(() {
      _version = version;
      // _buildNumber = buildNumber;
      // _buildSignature = buildSignature;
      // _appName = appName;
      // _packageName = packageName;
      // _installerStore = installerStore;

      if (_version.toString() != version1.toString()) {
        showdialogFunc();
        print(version1);
        print(_version.toString());
        print(appName);
      } else {
        print('printeyyy');
        print(forceUpdatecontroller.orderID.toString());
        print(appName);
      }
    });
  }

  LoginController loginController = Get.put(LoginController());
  var selectedindex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: Helper.of(context).onWillPop,
      child: Obx(() {
        if (homeController.homeLoad.value) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (homeController.gethome.isEmpty) {
          return Center(
            child: Text('No Data Found'),
          );
        }
        return Scaffold(
            key: _scaffoldKey,
            backgroundColor: black,
            drawer: Drawer(
              backgroundColor: black,
              child: Column(children: [
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(color: black),
                  accountName: Text(
                    "CLive OTT",
                    style: TextStyle(fontSize: 18),
                  ),
                  accountEmail: Text(
                    "Watch now",
                    style: TextStyle(color: Colors.red[900]),
                  ),
                  //currentAccountPictureSize: Size.square(50),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: black,
                    backgroundImage: AssetImage('assets/images/clive.png'),
                  ),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.home,
                    color: screenbackground,
                  ),
                  title: InkWell(
                    focusColor: Colors.blue.withOpacity(0.4),
                    onTap: () {
                      Get.back();
                      //Get.to(Homescreen());
                    },
                    child: Container(
                      width: 30.0.w,
                      height: 30.h,
                      child: Text(
                        ' Home ',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.live_tv,
                    color: screenbackground,
                  ),
                  title: InkWell(
                    focusColor: Colors.blue.withOpacity(0.4),
                    onTap: () {
                      Get.back();
                      Get.to(LiveChannels());
                    },
                    child: Container(
                      width: 30.0.w,
                      height: 30.h,
                      child: Text(
                        'Live Tv',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.login,
                    color: screenbackground,
                  ),
                  title: InkWell(
                    focusColor: Colors.blue.withOpacity(0.4),
                    onTap: () {
                      loginController.logout();
                    },
                    child: Container(
                      width: 30.0.w,
                      height: 30.h,
                      child: Text(
                        'Logout',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),

                  //UserAccountDrawerHeader
                ),
                // ListTile(
                //   leading: const Icon(
                //     Icons.login,
                //     color: screenbackground,
                //   ),
                //   title: InkWell(
                //     focusColor: Colors.blue.withOpacity(0.4),
                //     onTap: () {
                //       Get.to(MyWatchlist());
                //     },
                //     child: Container(
                //       width: 30.0.w,
                //       height: 30.h,
                //       child: Text(
                //         'My Watchlist ',
                //         style: TextStyle(color: Colors.white),
                //       ),
                //     ),
                //   ),
                // )

                //   //UserAccountDrawerHeader
                // )
              ]),
            ),
            appBar: AppBar(
              // toolbarHeight: 10.0.hp,
              backgroundColor: black1,

              leading: InkWell(
                  focusColor: Colors.red,
                  onTap: () {
                    _scaffoldKey.currentState!.openDrawer();
                  },
                  child: Icon(Icons.list)),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _isTV!
                          ? Image.asset(
                              'assets/images/clive.png',
                              height: 30.0.w,
                            )
                          : Container(
                              width: 0.0.w,
                            ),
                      SizedBox(
                        width: 2.0.wp,
                      ),
                      InkWell(
                          onTap: () {
                            setState(() {
                              selectedindex = 0;
                            });
                          },
                          focusColor: Colors.blue.withOpacity(0.4),
                          child: Container(
                              width: 60.0.w,
                              child: Center(
                                  child: selectedindex == 0
                                      ? Text(
                                          'Home',
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                              color: Colors.amber[700]),
                                        )
                                      : Text(
                                          'Home',
                                          style: TextStyle(),
                                        )))),
                      InkWell(
                          onTap: () {
                            setState(() {
                              selectedindex = 1;
                            });
                          },
                          focusColor: Colors.blue.withOpacity(0.4),
                          child: Container(
                              width: 80.0.w,
                              child: Center(
                                  child: selectedindex == 1
                                      ? Text(
                                          'Live TV',
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                              color: Colors.amber[700]),
                                        )
                                      : Text(
                                          'Live TV',
                                          style: TextStyle(),
                                        )))),
                      InkWell(
                          onTap: () {
                            setState(() {
                              selectedindex = 2;
                            });
                          },
                          focusColor: Colors.blue.withOpacity(0.4),
                          child: Container(
                              width: 80.0.w,
                              child: Center(
                                  child: selectedindex == 2
                                      ? Text(
                                          'Movies',
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                              color: Colors.amber[700]),
                                        )
                                      : Text(
                                          'Movies',
                                          style: TextStyle(),
                                        )))),
                    ],
                  ),
                  Row(
                    children: [
                      // InkWell(
                      //     onTap: () {
                      //       setState(() {
                      //         selectedindex = 3;
                      //       });
                      //     },
                      //     focusColor: Colors.blue.withOpacity(0.4),
                      //     child: Container(
                      //         width: 35.0.w,
                      //         height: 4.0.hp,
                      //         decoration: BoxDecoration(
                      //           borderRadius: BorderRadius.circular(5),
                      //           color: Colors.amber[900],
                      //         ),
                      //         child: Row(
                      //           mainAxisAlignment:
                      //               MainAxisAlignment.spaceAround,
                      //           children: [
                      //             Center(
                      //                 child: Image.asset(
                      //               'assets/images/watchlist.png',
                      //               height: 3.0.hp,
                      //             )),
                      //             Center(
                      //                 child: Text(
                      //               'MyWatchlist',
                      //               style: datetimecolor,
                      //             ))
                      //           ],
                      //         ))),
                      InkWell(
                          onTap: () {
                            setState(() {
                              selectedindex = 3;
                            });
                          },
                          focusColor: Colors.blue.withOpacity(0.4),
                          child: Container(
                              width: 30.0.w,
                              child: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: clivecolor,
                                  child: Icon(Icons.person)))),
                    ],
                  )
                ],
              ),
              //centerTitle: true,
            ),
            body: selectedindex == 0
                ? SingleChildScrollView(
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          //   image: AssetImage("assets/images/background.png"),
                          image: AssetImage('assets/images/loginbg.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  print('Printttt');
                                },
                                child: Container(
                                    height: 10.0.h,
                                    width: 100.0.wp,
                                    color: Colors.black.withOpacity(0.2),
                                    child: Text('')),
                              ),
                            ),
                            _isTV! ? SlidingBannerAuto() : ImageSliderHome(),
                            SizedBox(
                              height: 2.0.hp,
                            ),
                            _isTV!
                                ? Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Image.asset(
                                        'assets/images/ads1.jpg',
                                        height: 35.0.hp,
                                        width: 100.0.wp,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child:
                                        Image.asset('assets/images/ads1.jpg'),
                                  ),
                            // Text('Version : ${_version ?? '-'}'),
                            SizedBox(
                              height: 3.0.h,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Premium(),
                            ),
                            SizedBox(
                              height: 3.0.h,
                            ),
                            LatestPage(),
                            Padding(
                              padding: const EdgeInsets.only(left: 18.0),
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
                                  Text('Popular Movies',
                                      style: toptitleStylebold),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Categorylist(),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: HomeSectionThree(),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.all(8.0),
                            //   child: HomeSectionFour(),
                            // )
                          ],
                        ),
                      ),
                    ),
                  )
                : selectedindex == 1
                    ? SingleChildScrollView(
                        child: Container(
                          height: 1000.0.h,
                          width: 1000.0.w,
                          // decoration: BoxDecoration(
                          //   image: DecorationImage(
                          //     image: AssetImage("assets/images/bgbg.jpg"),
                          //     fit: BoxFit.cover,
                          //   ),
                          // ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                LiveTvCategoryScreen()
                                //  LiveTvCatgeoryPage(),
                                // MusicLivePage(),
                                // NewsPage(),
                                // LifeStylePage(),
                                // Religious(),
                                // DevotionalPage(),
                                // OthersPage()
                              ],
                            ),
                          ),
                        ),
                      )
                    : selectedindex == 2
                        ? MoviesPage()
                        : EditProfileScreen());
      }),
    );
  }
}
