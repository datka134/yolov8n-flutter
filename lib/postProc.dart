import 'dart:math';

List<List<double>> filledBox(List<List<List<double>>> output, double classThreshold, double iouThreshold ,int input_width,
                                         int input_height, double conf_threshold)  {
      
      try {
            //model_outputs = [1,box+class,detected_box]
            List<List<double>> pre_box = []; 
            int class_index = 4;
            int dimension = output[0][0].length;
            int rows = output[0].length;
            int max_index = 0;
            double max = 0;
            for (int i = 0; i < dimension; i++) {
                double x1 = (output[0][0][i] - output[0][2][i] / 2.0)* input_width;
                double y1 = (output[0][1][i] - output[0][3][i] / 2.0)* input_height;
                double x2 = (output[0][0][i] + output[0][2][i] / 2.0)* input_width;
                double y2 = (output[0][1][i] + output[0][3][i] / 2.0)* input_height;
                max_index = class_index;
                max = output[0][max_index][i];

                for (int j = class_index + 1; j < rows; j++) {
                    double current = output[0][j][i];
                    if (current > max) {
                        max = current;
                        max_index = j;
                    }
                }

                if (max > classThreshold) {
                    List<double> tmp = List<double>.filled(6, 0.0);
                    tmp[0] = x1;
                    tmp[1] = y1;
                    tmp[2] = x2;
                    tmp[3] = y2;
                    tmp[4] = max;
                    tmp[5] = (max_index - class_index) * 1.0;
                    pre_box.add(tmp);
                }
            }
            if (pre_box.isEmpty) return [];
            //for reverse orden, insteand of using .reversed method
            pre_box.sort((v1, v2) => v2[4].compareTo(v1[4]));
            //Collections.sort(pre_box,compareValues.reversed());
            return nms(pre_box, iouThreshold);
        } on Exception catch (_, e) {
            throw e;
        }
    }
    List<List<double>> nms(List<List<double>> boxes, double iouThreshold) {
        try {
            List<List<double>> filteredBoxes = List.from(boxes); // Create a copy of the input list

            for (int i = 0; i < filteredBoxes.length; i++) {
                List<double> box = filteredBoxes[i].cast<double>();
                for (int j = i + 1; j < filteredBoxes.length; j++) {
                    List<double> next_box = filteredBoxes[j].cast<double>();
                    double x1 = max(next_box[0], box[0]);
                    double y1 = max(next_box[1], box[1]);
                    double x2 = min(next_box[2], box[2]);
                    double y2 = min(next_box[3], box[3]);

                    double width = max(0, x2 - x1);
                    double height = max(0, y2 - y1);

                    double intersection = width * height;
                    double union = (next_box[2] - next_box[0]) * (next_box[3] - next_box[1])
                            + (box[2] - box[0]) * (box[3] - box[1]) - intersection;
                    double iou = intersection / union;
                    if (iou > iouThreshold) {
                        filteredBoxes.removeAt(j);
                        j--;
                    }
                }
            }
            return filteredBoxes;
        } on Exception catch (_, e) {
            
            throw e;
        }
      }

      List<List<double>> restoreSize(List<List<double>> nms,
                                         int input_width,
                                         int input_height,
                                         int src_width,
                                         int src_height) {
        try {
            //restore size after scaling, larger images
            if (src_width > input_width || src_height > input_height) {
                double gainx = src_width /  input_width;
                double gainy = src_height / input_height;
                for (int i = 0; i < nms.length; i++) {
                    nms[i][0] = min(src_width.toDouble(), max(nms[i][0] * gainx, 0));
                    nms[i][1] = min(src_height.toDouble(), max(nms[i][1] * gainy, 0));
                    nms[i][2] = min(src_width.toDouble(), max(nms[i][2] * gainx, 0));
                    nms[i][3] = min(src_height.toDouble(), max(nms[i][3] * gainy, 0));
                }
                //restore size after padding, smaller images
            } else {
                double padx = (src_width - input_width) / 2.0;
                double pady = (src_height - input_height) / 2.0;
                for (int i = 0; i < nms.length; i++) {
                    nms[i][0] = min(src_width.toDouble(), max(nms[i][0] + padx, 0));
                    nms[i][1] = min(src_height.toDouble(), max(nms[i][1] + pady, 0));
                    nms[i][2] = min(src_width.toDouble(), max(nms[i][2] + padx, 0));
                    nms[i][3] = min(src_height.toDouble(), max(nms[i][3] + pady, 0));
                }
            }
            return nms;
        } on Exception catch (_, e) {
            throw e;
            }
            }
        List<Map<String, Object>> out(List<List<double>> yoloResult) {
          try {
            List<Map<String, Object>> result = [];
            for (List<double> box in yoloResult) {
              Map<String, Object> output = {};
              output['box'] = [box[0], box[1], box[2], box[3], box[4]]; // x1, y1, x2, y2, conf_class
              // output['tag'] = labels[box[5].toInt()];
              result.add(output);
            }
            return result;
          } catch (e) {
            rethrow;
          }
        }