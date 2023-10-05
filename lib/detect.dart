// import 'package:tflite_flutter/tflite_flutter.dart';
import 'detect_service.dart';
import 'screen_params.dart';
import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
// import 'stats_widget.dart';
// import 'recognition.dart';
import 'objectpainter.dart';
class Detect extends StatefulWidget {
  final List<CameraDescription> cameras;
  const Detect({super.key, required this.cameras});
  @override
  // ignore: library_private_types_in_public_api
  _DetectState createState() =>  _DetectState();


} 


class _DetectState extends State<Detect>  with WidgetsBindingObserver  {
  late CameraImage img;
  late CameraController cameraController;
  bool isBusy = false;
  dynamic inputImage;
  dynamic image;
  List<CameraDescription>? cameras;
  get _controller => cameraController;
  Map<String, String>? stats;
  Detector? _detector;
  StreamSubscription? _subscription;
  List<Widget> stackChildren =[];
  /// Results to draw bounding boxes
  List<dynamic> results =[];



  @override
    void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // final cameras = await availableCameras();
    // cameras[0] for back-camera
    cameraController = CameraController(
      widget.cameras[1],
      ResolutionPreset.low,
      enableAudio: false,
      imageFormatGroup: 
          ImageFormatGroup.bgra8888,  
    )..initialize().then((_) async {
        await _controller.startImageStream(onLatestImageAvailable);
        setState(() {});

        /// previewSize is size of each image frame captured by controller
        ///
        /// 352x288 on iOS, 240p (320x240) on Android with ResolutionPreset.low
        ScreenParams.previewSize = _controller.value.previewSize!;
      });
      Detector.start().then((instance) {
      setState(() {
        _detector = instance;
        _subscription = instance.resultsStream.stream.listen((values) {
          setState(() {
            results = values['rect'];
            // stats = values['stats'];
            // print(results);
          });
        });
      });
    });
  }

  // void _initStateAsync() async {
  //   // initialize preview and CameraImage stream
  //    await _initializeCamera();
  //   // Spawn a new isolate
    
  // }









  // _initializeCamera() async {
    
  // }




  
    
    
  @override
  Widget build(BuildContext context) {
    var tmp = MediaQuery.of(context).size;
    // ignore: unnecessary_null_comparison
    if (_controller != null || !_controller.value.isInitialized) {
      stackChildren.add(
        Positioned(
          top: 0.0,
          left: 0.0,
          width: tmp.width,
          height: tmp.height,
          child: Container(
            child: (_controller.value.isInitialized)
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: CameraPreview(_controller),
                  )
                : Container(),
          ),
        ),
      );
      stackChildren.add(
        Positioned(
            top: 0.0,
            left: 0.0,
            width: tmp.width,
            height: tmp.height,
            child: drawRectangleOverObjects()),
      );

    
    }
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: const Text("Face detector"),
      //   backgroundColor: const Color.fromARGB(255, 126, 0, 252),
      // ),
      // backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: Container(
                margin: const EdgeInsets.only(top: 0),
                color: Colors.black,
                child: Stack(
                  children: stackChildren,
                )),
          ),
          // Container(
          //     color: Colors.white,
          //     height: MediaQuery.of(context).size.width * 0.30,
          //     width: MediaQuery.of(context).size.width,
          //     child: const Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         Text('đang nhận diện:', style: TextStyle(fontSize: 21)),
          //       ],
          //     )),
        ],
      ),
    );

  }

  // Widget _statsWidget() => (stats != null)
  //     ? Align(
  //         alignment: Alignment.bottomCenter,
  //         child: Container(
  //           color: Colors.white.withAlpha(150),
  //           child: Padding(
  //             padding: const EdgeInsets.all(16.0),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: stats!.entries
  //                   .map((e) => StatsWidget(e.key, e.value))
  //                   .toList(),
  //             ),
  //           ),
  //         ),
  //       )
  //     : const SizedBox.shrink();

  /// Returns Stack of bounding boxes
  Widget drawRectangleOverObjects() {
    if (results == null ||
         _controller == null ||
        !_controller.value.isInitialized) {
      return  const Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('Loading...'),
          CircularProgressIndicator(),
        ]),
      );
    }

    final Size imageSize = Size(
      _controller.value.previewSize!.height,
      _controller.value.previewSize!.width,
    );
    // drawImg = getInputImage();
    CustomPainter painter = ObjectPainter(
        imageSize, results);
    return CustomPaint(
      painter: painter,
    );
  }

  /// Callback to receive each frame [CameraImage] perform inference on it
  void onLatestImageAvailable(CameraImage cameraImage) async {
    _detector?.processFrame(cameraImage);
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) async {
  //   switch (state) {
  //     case AppLifecycleState.inactive:
  //       cameraController.stopImageStream();
  //       _detector?.stop();
  //       _subscription?.cancel();
  //       break;
  //     case AppLifecycleState.resumed:
  //       _initStateAsync();
  //       break;
  //     default:
  //   }
  // }
  
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // cameraController.dispose();
    _detector?.stop();
    _subscription?.cancel();
    super.dispose();
  }
}


  

 
    

  


