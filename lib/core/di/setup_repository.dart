import 'package:danielabake/core/utils/getx_helper.dart';
import 'package:danielabake/features/auth/repositories/auth_repository.dart';
import 'package:danielabake/features/auth/repositories/auth_repository_impl.dart';
import 'package:get/get.dart';

void setupRepository() {
  Get.getOrPut<AuthRepository>(() => AuthRepositoryImpl(apiClient: Get.find()));
}
