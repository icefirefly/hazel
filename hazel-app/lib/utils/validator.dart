import 'package:hazel/utils/consts.dart';

class Validator {
  static bool isValidSensorId(int id) {
    return id >= SENSOR_ID_1 && id <= SENSOR_ID_8;
  }

  static bool isValidLabelId(int id) {
    return id >= LABEL_ID_1 && id <= LABEL_ID_4;
  }
}
