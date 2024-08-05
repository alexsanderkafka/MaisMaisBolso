import 'package:flutter/material.dart';
import 'package:maismaisbolso/view/configs/colors_config.dart';
import 'package:maismaisbolso/view/view_home.dart';

class ViewSplashScreen extends StatefulWidget {
  const ViewSplashScreen({super.key});

  @override
  State<ViewSplashScreen> createState() => _ViewSplashScreenState();
}

class _ViewSplashScreenState extends State<ViewSplashScreen>
    with SingleTickerProviderStateMixin {

  //late AnimationController animationController;

  @override
  void initState() {
    super.initState();
  }

  void _done () async{
    await Future.delayed(const Duration(seconds: 3));

    if(mounted){
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ViewHome()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _done();
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          color: ColorsConfig.yellowOne,
        ),
        child: Center(
          child: LogoSplash.logo("++Bolso"),
        ),
      ),
    );
  }
}

class LogoSplash{
  static Widget logo(String name){
    return Text(
      name,
      style: const TextStyle(
        color: Colors.white,
        fontFamily: "Roboto",
        fontSize: 64,
        fontWeight: FontWeight.w400,
        shadows: <Shadow>[
          Shadow(
            offset: Offset(2.0, 2.0),
            blurRadius: 5.0,
            color: Colors.black,
          ),
          Shadow(
            offset: Offset(2.0, 2.0),
            blurRadius: 5.0,
            color: Colors.black,
          )
        ],
      ),
    );
  }
}
