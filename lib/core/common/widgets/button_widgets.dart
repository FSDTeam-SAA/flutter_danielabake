import 'package:danielabake/core/base/base_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final Future<void> Function()? onApiPressed; // For API calls (with loading)
  final VoidCallback? onSimplePressed; // For navigation/local actions
  final String? tag;
  final String text;
  final double? width;
  final double? height;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  const PrimaryButton({
    super.key,
    this.onApiPressed,
    this.onSimplePressed,
    this.tag,
    required this.text,
    this.width,
    this.height = 50,
    this.backgroundColor = AppColors.primaryWhite,
    this.textColor = AppColors.primaryBlack,
    this.borderRadius = 48.0,
  });

  String get _uniqueTag => tag ?? text;

  @override
  Widget build(BuildContext context) {
    final isLoading = Get.put(false.obs, tag: _uniqueTag);

    return GestureDetector(
      onTap: onApiPressed != null
          ? () async {
              if (isLoading.value) return;
              isLoading.value = true;

              try {
                await onApiPressed!();
              } catch (e) {
                Get.snackbar(
                  "Error",
                  e.toString(),
                  backgroundColor: Colors.red[600],
                  colorText: Colors.white,
                );
              } finally {
                isLoading.value = false;
                // Optional: auto cleanup after 10 sec
                Future.delayed(const Duration(seconds: 10), () {
                  if (Get.isRegistered<RxBool>(tag: _uniqueTag)) {
                    Get.delete<RxBool>(tag: _uniqueTag);
                  }
                });
              }
            }
          : onSimplePressed,
      child: Obx(() {
        return AbsorbPointer(
          absorbing: isLoading.value,
          child: Opacity(
            opacity: isLoading.value ? 0.6 : 1.0,
            child: Container(
              width: width ?? double.infinity,
              height: height ?? 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                // color: backgroundColor,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  transform: GradientRotation(178.12 * 3.1416 / 180),
                  colors: [
                    AppColors.primaryButtonDeep.withAlpha((0.7 * 255).toInt()),
                    AppColors.primaryButtonBright.withAlpha(
                      (0.7 * 255).toInt(),
                    ),
                  ],
                  stops: [0.44, 0.88],
                ),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              child: isLoading.value
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(textColor),
                      ),
                    )
                  : Text(
                      text,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppColors.primaryWhite,
                      ),
                    ),
            ),
          ),
        );
      }),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final Future<void> Function()? onApiPressed; // For API calls (with loading)
  final VoidCallback? onSimplePressed; // For navigation/local actions
  final BaseController? loadingController;
  final String? tag;
  final String text;
  final double? width;
  final double? height;
  final Color borderColor;
  final Color textColor;
  final Color? backgroundColor;
  final double borderRadius;
  final double borderWidth;

  const SecondaryButton({
    super.key,
    this.onApiPressed,
    this.onSimplePressed,
    this.loadingController,
    this.tag,
    required this.text,
    this.width,
    this.height = 50,
    this.borderColor = AppColors.primaryButtonBright,
    this.textColor = AppColors.primaryBlack,
    this.backgroundColor,
    this.borderRadius = 48.0,
    this.borderWidth = 1.0,
  });

  String get _uniqueTag => tag ?? text;

  @override
  Widget build(BuildContext context) {
    final isLoading = Get.put(false.obs, tag: _uniqueTag);

    return GestureDetector(
      onTap: onApiPressed != null
          ? () async {
              if (isLoading.value) return;
              isLoading.value = true;

              try {
                await onApiPressed!();
              } catch (e) {
                Get.snackbar(
                  "Error",
                  e.toString(),
                  backgroundColor: Colors.red[600],
                  colorText: Colors.white,
                );
              } finally {
                isLoading.value = false;
                // Optional: auto cleanup after 10 sec
                Future.delayed(const Duration(seconds: 10), () {
                  if (Get.isRegistered<RxBool>(tag: _uniqueTag)) {
                    Get.delete<RxBool>(tag: _uniqueTag);
                  }
                });
              }
            }
          : onSimplePressed,
      child: Obx(() {
        return AbsorbPointer(
          absorbing: isLoading.value,
          child: Opacity(
            opacity: isLoading.value ? 0.6 : 1.0,
            child: Container(
              width: width ?? double.infinity,
              height: height ?? 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: backgroundColor ?? Colors.transparent,
                borderRadius: BorderRadius.circular(borderRadius),
                border: Border.all(color: borderColor, width: borderWidth),
              ),
              child: isLoading.value
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(textColor),
                      ),
                    )
                  : Text(
                      text,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: AppColors.primaryButtonBright,
                      ),
                    ),
            ),
          ),
        );
      }),
    );
  }
}
