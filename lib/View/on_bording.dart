import 'package:android_power_manager/android_power_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_silent/View/tab_bar.dart';
import 'package:smart_silent/constants.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:sound_mode/permission_handler.dart';

class OnBordingScreen extends StatefulWidget {
  const OnBordingScreen({super.key});

  @override
  State<OnBordingScreen> createState() => _OnBordingScreenState();
}

class _OnBordingScreenState extends State<OnBordingScreen> {
  String _isIgnoringBatteryOptimizations = 'Unknown';
  var controller = PageController();
  bool isFirstPage = true;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          padding: EdgeInsets.only(bottom: 50),
          child: PageView(
            controller: controller,
            onPageChanged: (index) {
              setState(() {
                isFirstPage = index == 0;
              });
              setState(() {
                isLastPage = index == 3;
              });
            },
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: AppColors.kbg,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/bg.png'),
                        SizedBox(
                          height: 20,
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              style: Theme.of(context).textTheme.displayMedium,
                              children: [
                                TextSpan(
                                    text: 'Welcome',
                                    style: TextStyle(color: AppColors.kPrimary)),
                                TextSpan(
                                  text:
                                      '\nKeep your phone silent when you are busy and stay safe from embarrasing moments.',
                                  style: Theme.of(context).textTheme.subtitle1,
                                )
                              ]),
                        ),
                      ]),
                ),
              ),
              Container(
                color: AppColors.kbg,
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/dnd.jpeg',
                      width: MediaQuery.of(context).size.width / 1.2,
                    ),
                    SizedBox(
                      height: 140,
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          style: Theme.of(context).textTheme.displayMedium,
                          children: [
                            TextSpan(
                                text: 'Do Not Disturb',
                                style: TextStyle(color: AppColors.kPrimary)),
                            TextSpan(
                              text:
                                  '\n We need this permissions only for the first time',
                              style: Theme.of(context).textTheme.caption,
                            )
                          ]),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                                style: Theme.of(context).textTheme.subtitle1,
                                children: [
                                  TextSpan(
                                      text:
                                          'Please Allow donot disturb mode.Otherwise App may not work properly.'),
                                ]),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            openDoNotDisturbSettings();
                            controller.nextPage(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeInOut);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: AppColors.kPrimary,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(30),
                                ),
                                border: Border.all(color: Colors.black)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Open Settings",
                                  style: TextStyle(
                                      color: AppColors.kbg,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                )),
              ),
              Container(
                color: AppColors.kbg,
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LottieBuilder.asset(
                      "assets/battery.json",
                      width: MediaQuery.of(context).size.width / 2,
                      fit: BoxFit.fill,
                    ),
                    // Image.asset('assets/images/battery.jpeg',
                    // width:MediaQuery.of(context).size.width/1.5 ,),
                    SizedBox(
                      height: 20,
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          style: Theme.of(context).textTheme.displayMedium,
                          children: [
                            TextSpan(
                                text: 'Battery Saver',
                                style: TextStyle(color: AppColors.kPrimary)),
                            TextSpan(
                              text:
                                  '\n We need this permissions only for the first time.',
                              style: Theme.of(context).textTheme.caption,
                            )
                          ]),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                                style: Theme.of(context).textTheme.subtitle1,
                                children: [
                                  TextSpan(
                                      text:
                                          'Please set to no restirctions.Otherwise App may not work properly.'),
                                ]),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () async {
                            final success = await AndroidPowerManager
                                .requestIgnoreBatteryOptimizations();
                            if (success ?? false) {
                              String isIgnoringBatteryOptimizations =
                                  await _checkBatteryOptimizations();
                              setState(() {
                                _isIgnoringBatteryOptimizations =
                                    isIgnoringBatteryOptimizations;
                              });
                            } else {
                              print("good to goo");
                            }
                            controller.nextPage(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeInOut);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: AppColors.kPrimary,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(30),
                                ),
                                border: Border.all(color: Colors.black)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Open Settings",
                                  style: TextStyle(
                                      color: AppColors.kbg,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                )),
              ),
              Container(
                color: AppColors.kbg,
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/bg.png'),
                    SizedBox(
                      height: 20,
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          style: Theme.of(context).textTheme.displayMedium,
                          children: [
                            TextSpan(
                                text: 'All Done',
                                style: TextStyle(color: AppColors.kPrimary)),
                          ]),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                                style: Theme.of(context).textTheme.subtitle1,
                                children: [
                                  TextSpan(
                                      text:
                                          'Now Schedule for hassle-free peaceful moments.'),
                                ]),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () async {
                            var prefs = await SharedPreferences.getInstance();
                            prefs.setBool('showHome', true);
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => TabBarDemo()));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: AppColors.kPrimary,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(30),
                                ),
                                border: Border.all(color: Colors.black)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Continue",
                                  style: TextStyle(
                                      color: AppColors.kbg,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                )),
              ),
            ],
          ),
        ),
        bottomSheet: isLastPage
            ? TextButton(
                style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    shadowColor: Colors.amber,
                    backgroundColor: AppColors.kPrimary,
                    minimumSize: Size.fromHeight(80),
                    primary: AppColors.kbg),
                onPressed: () async {
                  var prefs = await SharedPreferences.getInstance();
                  prefs.setBool('showHome', true);
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => TabBarDemo()));
                },
                child: Text(
                  "Get Sarted",
                ))
            : Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                height: 80,
                child: Row(
                  children: [
                    isFirstPage
                        ? SizedBox()
                        : TextButton(
                            onPressed: () {
                              controller.previousPage(
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.easeInOut);
                            },
                            child: Icon(
                              Icons.arrow_back,
                              color: AppColors.kPrimary,
                            )),
                    Spacer(),
                    Center(
                      child: SmoothPageIndicator(
                        controller: controller,
                        count: 3,
                        effect: WormEffect(activeDotColor: AppColors.kPrimary),
                        onDotClicked: (index) => controller.animateToPage(index,
                            duration: Duration(microseconds: 500),
                            curve: Curves.easeIn),
                      ),
                    ),
                    Spacer(),
                    TextButton(
                        onPressed: () {
                          controller.nextPage(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInOut);
                        },
                        child: Icon(
                          Icons.arrow_forward,
                          color: AppColors.kPrimary,
                        ))
                  ],
                ),
              ),
      ),
    );
  }

  Future<void> initPlatformState() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    String isIgnoringBatteryOptimizations = await _checkBatteryOptimizations();
    setState(() {
      _isIgnoringBatteryOptimizations = isIgnoringBatteryOptimizations;
    });
  }

  Future<String> _checkBatteryOptimizations() async {
    String isIgnoringBatteryOptimizations;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      isIgnoringBatteryOptimizations =
          '${await AndroidPowerManager.isIgnoringBatteryOptimizations}';
    } on PlatformException {
      isIgnoringBatteryOptimizations = 'Failed to get platform version.';
    }
    return isIgnoringBatteryOptimizations;
  }

  Future<void> openDoNotDisturbSettings() async {
    await PermissionHandler.openDoNotDisturbSetting();
  }
}
