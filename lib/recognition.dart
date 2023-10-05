import 'package:flutter/cupertino.dart';
import 'screen_params.dart';

/// Represents the recognition output from the model
// class DetectionResult {
//   // /// Index of the result
//   // final int _id;

//   // /// Label of the result
//   // final String _label;

//   // /// Confidence [0.0, 1.0]
//   // final double _score;

//   // /// Location of bounding box rect
//   // ///
//   // /// The rectangle corresponds to the raw input image
//   // /// passed for inference
//   // final Rect _location;

//   DetectionResult(this._id, this._label, this._score, this._location);

//   // int get id => _id;

//   // String get label => _label;

//   // double get score => _score;

//   // Rect get location => _location;

//   /// Returns bounding box rectangle corresponding to the
//   /// displayed image on screen
//   ///
//   /// This is the actual location where rectangle is rendered on
//   /// the screen
//   Rect get renderLocation {
//     final double scaleX = ScreenParams.screenPreviewSize.width / 300;
//     final double scaleY = ScreenParams.screenPreviewSize.height / 300;
//     return Rect.fromLTWH(
//       location.left * scaleX,
//       location.top * scaleY,
//       location.width * scaleX,
//       location.height * scaleY,
//     );
//   }

//   @override
//   String toString() {
//     return 'Recognition(id: $id, label: $label, score: $score, location: $location)';
//   }
// }
class FaceDetectionResult {
  final List<Detections> detections;

  FaceDetectionResult({required this.detections}); 
}

class Detections {
  final List<Detection> detection;

  Detections({required this.detection});
}

class Detection {
  final Rect boundingBox;
  final double score;
  Detection(this.score, {required this.boundingBox});
  


  Rect get renderLocation {
    final double scaleX = ScreenParams.screenPreviewSize.width / 128;
    final double scaleY = ScreenParams.screenPreviewSize.height / 128;
    return Rect.fromLTWH(
      boundingBox.left * scaleX,
      boundingBox.top * scaleY,
      boundingBox.width * scaleX,
      boundingBox.height * scaleY,
    );
  }

  // @override
  // String toString() {
  //   return 'Detection( score: $score, boundingBox: $boundingBox)';
  // }
}