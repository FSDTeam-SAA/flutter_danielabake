import 'package:danielabake/core/utils/getx_helper.dart';
import 'package:danielabake/features/auth/repositories/auth_repository.dart';
import 'package:danielabake/features/auth/repositories/auth_repository_impl.dart';
import 'package:danielabake/features/profile_screens/repositories/profile_repository.dart';
import 'package:get/get.dart';

import '../../features/profile_screens/repositories/profile_repository_impl.dart';

void setupRepository() {
  Get.getOrPut<AuthRepository>(() => AuthRepositoryImpl(apiClient: Get.find()));
  Get.getOrPut<ProfileRepository>(() => ProfileRepositoryImpl(apiClient: Get.find()));
}
