import 'dart:async';

import 'package:flutter/material.dart';

import 'initial_app.dart' if (dart.library.hmtl) 'initial_web_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const InitialApp());
}
