import 'package:danielabake/core/utils/getx_helper.dart';
import 'package:danielabake/features/Order_screen/repositories/cart_repository.dart';
import 'package:danielabake/features/Order_screen/repositories/cart_repository_impl.dart';
import 'package:danielabake/features/Order_screen/repositories/place_order_repo.dart';
import 'package:danielabake/features/Order_screen/repositories/place_order_repo_impl.dart';
import 'package:danielabake/features/auth/repositories/auth_repository.dart';
import 'package:danielabake/features/auth/repositories/auth_repository_impl.dart';
import 'package:danielabake/features/home/repositories/cart_repository.dart';
import 'package:danielabake/features/home/repositories/cart_repository_impl.dart';
import 'package:danielabake/features/home/repositories/category_repository.dart';
import 'package:danielabake/features/home/repositories/category_repository_impl.dart';
import 'package:danielabake/features/home/repositories/favorite_food_repository.dart';
import 'package:danielabake/features/home/repositories/favorite_food_repository_impl.dart';
import 'package:danielabake/features/home/repositories/home_repository.dart';
import 'package:danielabake/features/home/repositories/home_repository_impl.dart';
import 'package:danielabake/features/profile_screens/repositories/profile_repository.dart';
import 'package:get/get.dart';

import '../../features/profile_screens/repositories/profile_repository_impl.dart';

void setupRepository() {
  Get.getOrPut<AuthRepository>(() => AuthRepositoryImpl(apiClient: Get.find()));
  Get.getOrPut<ProfileRepository>(() => ProfileRepositoryImpl(apiClient: Get.find()));
  Get.getOrPut<CategoryRepository>(() => CategoryRepositoryImpl(apiClient: Get.find()));
  Get.getOrPut<HomeRepository>(() => HomeRepositoryImpl(apiClient: Get.find()));
  Get.getOrPut<FavoriteFoodRepository>(() => FavoriteFoodRepositoryImpl(apiClient: Get.find()));
  Get.getOrPut<CartRepository>(() => CartRepositoryImpl(apiClient: Get.find()));
  Get.getOrPut<CartRepo>(() => CartRepoImpl(apiClient: Get.find()));
  Get.getOrPut<PlaceOrderRepo>(() => PlaceOrderRepoImpl(apiClient: Get.find()));
}
