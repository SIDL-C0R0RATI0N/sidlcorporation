import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:sidlcorporation/app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Orientation portrait uniquement
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const SidlApp());
}