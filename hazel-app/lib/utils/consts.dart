import 'package:flutter/material.dart';
import 'package:hazel/data/bsec_data.dart';
import 'package:hazel/utils/material_color_util.dart';

const DEFAULT_MTU = 158;
const Max_Gas_Estimates_To_Remember = 5;

//Shared preference keys
const String PREF_CONNECTED_DEVICE = "connectedDevice";
const String PREF_LABEL = "label";
const String PREF_LABEL_1 = "label1";
const String PREF_LABEL_2 = "label2";
const String PREF_LABEL_3 = "label3";
const String PREF_LABEL_4 = "label4";

//Generic app constants
const APP_HEADER_DISPLAY_NAME = "Hazel with BME688";
const APP_CHART_Y_AXIS_TITLE = "Normalized gas";
const APP_CHART_X_AXIS_TITLE = "Gas index";
const APP_MAX_CHART_COUNT = 50;
const APP_DEVICE_NAME_PREFIX = "bme68";

//App icons
const ICON_BLUETOOTH_LE = "assets/images/bluetooth-le.ico";
const ICON_DEMO = "assets/images/demo.ico";
const ICON_TESTING = "assets/images/testing.ico";
const ICON_ENVIRONMENT = "assets/images/environment.ico";
const ICON_LABEL_GROUND_TRUTH = "assets/images/label-edit.ico";
const ICON_SETTINGS = "assets/images/settings.ico";
const ICON_HAZEL = "assets/icon/hazel_icon.svg";
const ICON_HAZELNUT = "assets/images/hazelnut.svg";

//Sensor Ids
const int SENSOR_ID_1 = 0;
const int SENSOR_ID_2 = 1;
const int SENSOR_ID_3 = 2;
const int SENSOR_ID_4 = 3;
const int SENSOR_ID_5 = 4;
const int SENSOR_ID_6 = 5;
const int SENSOR_ID_7 = 6;
const int SENSOR_ID_8 = 7;

//Labels
const int LABEL_ID_1 = 1;
const int LABEL_ID_2 = 2;
const int LABEL_ID_3 = 3;
const int LABEL_ID_4 = 4;

const List<String> DEFAULT_LABEL_NAME = ["Air", "Nut", "Testklasse", "Label4"];

List<Color> DEFAULT_COLOR = [
  HAZEL_MATERIAL_COLOR,
  Colors.green,
  Colors.red,
  Colors.yellow
];

List<GasEstimate> NO_CLASSIFICATION = [
  GasEstimate(1, 0.0, 3.0),
  GasEstimate(2, 0.0, 3.0),
  GasEstimate(3, 0.0, 3.0),
  GasEstimate(4, 0.0, 3.0),
];

//NotifiablePropertyNames
const PROPERTY_CURRENT_SENSOR = "currentSensor";

//App UI colors
const HAZEL_LIGHT_BLUE = Color(0xffb4c7e7);
const HAZEL_GREEN = Color(0xffc3e5a9);
const HAZEL_RED = Color(0xfff28b6c);

MaterialColor HAZEL_MATERIAL_COLOR = createMaterialColor(HAZEL_LIGHT_BLUE);
