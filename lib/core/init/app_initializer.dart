import 'package:danielabake/core/network/socket_client.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../di/service_locator.dart';
import 'hive_intialization.dart';

class AppInitializer {
  static Future<void> initializeApp() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Limit total image cache
    PaintingBinding.instance.imageCache.maximumSize = 100; // 100 images
    PaintingBinding.instance.imageCache.maximumSizeBytes = 100 << 20; // 100 MB

    // Allow all orientations at app start
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    await HiveInitialization.initHive();

    setupServiceLocator();

    // SocketClient().connect();
    // // Wait for connection
    // SocketClient().onReady;
  }
}
