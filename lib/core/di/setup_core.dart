import 'package:danielabake/core/base/base_controller.dart';
import 'package:danielabake/core/utils/getx_helper.dart';
import 'package:get/get.dart';

import '../network/api_client.dart';
import '../network/services/auth_storage_service.dart';

void setupCore() {
  Get.getOrPut(() => BaseController());
  Get.getOrPutLazy(() => ApiClient(), fenix: true);
  Get.getOrPutLazy(() =>  AuthStorageService());
  // Get.getOrPutLazy(() => AuthenticateCheckService(Get.find(), Get.find()));
}
