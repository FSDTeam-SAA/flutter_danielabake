// lib/core/controllers/connectivity_controller.dart

import 'package:get/get.dart';
import '/core/network/services/connectivity_service.dart';

import '../common/screens/no_internet_screen.dart';

class ConnectivityController extends GetxController {
  final ConnectivityService _connectivityService = ConnectivityService.instance;
  bool _isShowingNoInternet = false;

  @override
  void onInit() {
    super.onInit();
    // Initialize connectivity service
    _connectivityService.initialize();
    // Listen to connectivity changes
    _connectivityService.connectivityStream.listen((isConnected) {
      _handleConnectivityChange(isConnected);
    });
  }

  void _handleConnectivityChange(bool isConnected) {
    if (!isConnected && !_isShowingNoInternet) {
      // Show No Internet screen when connectivity is lost
      _isShowingNoInternet = true;
      Get.to(() => const NoInternetScreen(), transition: Transition.fade);
    } else if (isConnected && _isShowingNoInternet) {
      // Go back to the previous screen when connectivity is restored
      _isShowingNoInternet = false;
      Get.back();
    }
  }

  @override
  void onClose() {
    // Dispose of connectivity service when controller is closed
    _connectivityService.dispose();
    super.onClose();
  }
}
