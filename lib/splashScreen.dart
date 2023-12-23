import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({required Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: (200)),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
        body:  Center(child: Column(
          children: [
            SizedBox(
              width: 10,
              height: 20,
            ),
            Image(image: AssetImage("assets/splashlogo.png"),
              width: 300,
              height: 300,
              fit: BoxFit.contain,
            ),
            Container(
              width: 200,
              height: 200,
              child:   DotLottieLoader.fromAsset("assets/load1.lottie",
                  frameBuilder: (ctx, dotlottie) {
                    if (dotlottie != null) {
                      return Lottie.memory(
                        dotlottie.animations.values.single,
                        controller: _controller,
                        onLoaded: (composition) {
                          _controller
                            ..duration = composition.duration
                            ..forward().whenComplete(() =>
                                Navigator.pushReplacementNamed(context, '/LoginPage')
                            );
                        },
                      );
                    } else {
                      return Container();
                    }
                  }),
            ),
          ],
        ),)

    );
  }
}

