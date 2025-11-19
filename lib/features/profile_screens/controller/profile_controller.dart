import 'dart:developer' as DPrint;
import 'dart:io';
import 'package:danielabake/features/profile_screens/models/request/current_password_update_request_model.dart';
import 'package:danielabake/features/profile_screens/models/response/get_favorite_items_response_model.dart';
import 'package:danielabake/features/profile_screens/models/response/get_profile_response_model.dart';
import 'package:danielabake/features/profile_screens/models/response/ongoing_order_response_model.dart';
import 'package:get/get.dart';
import '../../../../core/base/base_controller.dart';
import '../../../core/network/services/auth_storage_service.dart';
import '../../../core/network/services/multiple_form_data_manager.dart';
import '../repositories/profile_repository.dart';

class ProfileController extends BaseController {
  final _profileRepository = Get.find<ProfileRepository>();
  final AuthStorageService _authStorageService = AuthStorageService();

  final Rxn<GetProfileResponseModel> userInfo = Rxn<GetProfileResponseModel>();
  final Rxn<OngoingOrderResponseModel> ongoingOrder = Rxn<OngoingOrderResponseModel>();
  final MultiFormDataManager _multiFormDataManager = MultiFormDataManager();
  final favoriteItems = <GetFavoriteItemsResponseModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile(); //Fetch when controller is created
    fetchOngoingOrders();
    fetchFavoriteItem();
  }

  Future<void> fetchProfile() async {
    final userId = await _authStorageService.getUserId();
    DPrint.log('UserId: $userId');
    if (userId == null || userId.isEmpty) {
      setError('User ID not found. Please log in again.');
      Get.snackbar('Error', 'User ID not found. Please log in again.');
      setLoading(false);
      return;
    }

    final result = await _profileRepository.fetchProfile(userId);

    result.fold(
      (fail) {
        setError(fail.message);
        DPrint.log('data fetch failed');
      },
      (success) {
        userInfo.value = success.data;
        DPrint.log(success.message);
      },
    );
  }

  Future<void> updatePersonalInfo(
    String fullName,
    String phoneNumber, File? image
  ) async {

    final userId = await _authStorageService.getUserId();
    DPrint.log('UserId: $userId');

    if (userId == null || userId.isEmpty) {
      setError('User ID not found. Please log in again.');
      Get.snackbar('Error', 'User ID not found. Please log in again.');
      setLoading(false);
      return;
    }

    _multiFormDataManager.clearFiles("avatar");

    _multiFormDataManager.addTextData("fullName", fullName);
    _multiFormDataManager.addTextData("phone", phoneNumber);
    if (image != null) {
      _multiFormDataManager.addImageFile(image, key: "avatar");
    }


    final formRequest = await _multiFormDataManager.toFormDataAsync();

    final result = await _profileRepository.updatePersonalInfo(formRequest, userId);

    result.fold(
      (fail) {
        setError(fail.message);
        DPrint.log('Personal info: ${fail.message}');
      },
      (success) async {
        DPrint.log('Personal info: ${success.message}');
        await fetchProfile();
        Get.back();
        _multiFormDataManager.clear();
        setError(success.message);
      },
    );
  }

  //
  //
  Future<void> changePassword(String oldPassword, String newPassword) async{
    final request = UpdatePasswordRequestModel(newPassword: newPassword, currentPassword: oldPassword);
    final result = await _profileRepository.changePass(request);

    result.fold(
          (fail) {
        setError(fail.message);
        DPrint.log("change pass success result : ${fail.message}");
        setLoading(false);
      },
          (success) {
        DPrint.log("change pass success result : ${success.message}");
        Get.back();
        setLoading(false);
      },
    );
  }

  Future<void> fetchCtegory() async {
    final userId = await _authStorageService.getUserId();
    DPrint.log('UserId: $userId');
    if (userId == null || userId.isEmpty) {
      setError('User ID not found. Please log in again.');
      Get.snackbar('Error', 'User ID not found. Please log in again.');
      setLoading(false);
      return;
    }

    final result = await _profileRepository.fetchProfile(userId);

    result.fold(
          (fail) {
        setError(fail.message);
        DPrint.log('data fetch failed');
      },
          (success) {
        userInfo.value = success.data;
        DPrint.log(success.message);
      },
    );
  }

  Future<void> fetchOngoingOrders() async {

    final result = await _profileRepository.fetchOngoingOrder();

    result.fold(
          (fail) {
        setError(fail.message);
        DPrint.log('data fetch failed');
      },
          (success) {
        ongoingOrder.value = success.data;
        DPrint.log(success.message);
      },
    );
  }

  Future<void> fetchFavoriteItem() async {
    final userId = await _authStorageService.getUserId();
    DPrint.log('UserId: $userId');
    if (userId == null || userId.isEmpty) {
      setError('User ID not found. Please log in again.');
      Get.snackbar('Error', 'User ID not found. Please log in again.');
      setLoading(false);
      return;
    }

    final result = await _profileRepository.fetchFavoriteItems(userId);

    result.fold(
          (fail) {
        setError(fail.message);
        DPrint.log('data fetch failed');
      },
          (success) {
        favoriteItems.value = success.data;
        favoriteItems.refresh();
        DPrint.log(success.message);
      },
    );
  }

  //
  // Future<void> uploadPhoto(File image) async {
  //   setLoading(true);
  //   setError('');
  //
  //   _multiFormDataManager.addImageFile(image, key: "avatar");
  //
  //   final formRequest = await _multiFormDataManager.toFormDataAsync();
  //
  //   final result = await _profileRepository.uploadPhoto(formRequest);
  //
  //   result.fold(
  //         (fail) {
  //       setError(fail.message);
  //       DPrint.log('Upload photo: ${fail.message}');
  //       isLoading(false);
  //     },
  //         (success) {
  //       DPrint.log('Upload photo: ${success.message}');
  //       fetchProfile();
  //       Get.back();
  //       setError(success.message);
  //       _multiFormDataManager.clear();
  //       isLoading(false);
  //     },
  //   );
  // }
  //
  // Future<void> tradingProfileSetup(
  //     final String tradingExperience,
  //     final String assetsOfInterest,
  //     final String mainGoal,
  //     final String riskAppetite,
  //     final List<String> preferredLearning,
  //     ) async {
  //   setLoading(true);
  //   setError('');
  //
  //   final profile = TradingProfile(tradingExperience: tradingExperience, assetsOfInterest: assetsOfInterest, mainGoal: mainGoal, riskAppetite: riskAppetite, preferredLearning: preferredLearning);
  //   final toJson = jsonEncode(profile.toJson());
  //
  //
  //   _multiFormDataManager.addTextData("treding_profile", toJson);
  //
  //
  //   final formRequest = await _multiFormDataManager.toFormDataAsync();
  //
  //   final result = await _profileRepository.tradingInfo(formRequest);
  //
  //   result.fold(
  //         (fail) {
  //       setError(fail.message);
  //       DPrint.log('Trading info: ${fail.message}');
  //       isLoading(false);
  //     },
  //         (success) {
  //       DPrint.log('Trading info: ${success.message}');
  //       Get.back();
  //       isLoading(false);
  //
  //       _multiFormDataManager.clear();
  //       setError(success.message);
  //     },
  //   );
  // }
}
