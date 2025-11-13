// import 'package:get/get.dart';
// import '../../../core/network/services/auth_check_service.dart';
// import '../../home/screens/home_screen.dart';
//
// class NavigationController extends GetxController {
//   final _authenticateCheck = Get.find<AuthenticateCheckService>();
//
//   @override
//   Future<void> onInit() async {
//     super.onInit();
//
//     // Optional delay so splash logo is briefly visible
//     await Future.delayed(const Duration(seconds: 2));
//
//     // Check authentication
//     final isLoggedIn = await _authenticateCheck.isAuthenticated();
//
//     if (Get.isOverlaysOpen) return;
//     if (isLoggedIn) {
//       // If already logged in → skip splash and go to home
//       Get.offAll(() => HomeScreen());
//     }
//     // If not logged in → do nothing, user stays on SplashScreen
//   }
// }
