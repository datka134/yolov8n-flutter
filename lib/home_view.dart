import 'package:flutter/material.dart';
import 'screen_params.dart';
import 'detect.dart';
import 'package:camera/camera.dart';
late List<CameraDescription> cameras;

Future<Null> cam() async {
  // HttpOverrides.global = new MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error: $e.code\nError Message: $e.message');
  }
  
}




/// [HomeView] stacks [DetectorWidget]
class HomeView extends StatelessWidget {
  const HomeView({super.key, required this.cameras});
  final List<CameraDescription> cameras;
  @override
  Widget build(BuildContext context) {
    ScreenParams.screenSize = MediaQuery.sizeOf(context);
    return Scaffold(
      key: GlobalKey(),
      backgroundColor: Colors.black,
      // appBar: AppBar(
      //   title: Image.asset(
      //     'assets/images/tfl_logo.png',
      //     fit: BoxFit.contain,
      //   ),
      // ),
      body:  Detect( cameras: cameras,),
    );
  }
}