import 'package:danielabake/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final Color? backgroundColor;
  final AppBar? appBar;
  final Widget? drawer;
  final bool removePadding;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final bool circularBackButton;
  final Color? backButtonBackgroundColor;
  final Color? backButtonIconColor;
  final bool? isUnfocus;
  final double backButtonSize;

  const AppScaffold({
    super.key,
    this.appBar,
    this.backgroundColor,
    this.drawer,
    required this.body,
    this.removePadding = false,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.circularBackButton = true,
    this.backButtonBackgroundColor,
    this.backButtonIconColor,
    this.isUnfocus = true,
    this.backButtonSize = 40,
  });

  @override
  Widget build(BuildContext context) {
    AppBar? modifiedAppBar = appBar;

    // Only modify if circularBackButton is true, appBar exists, and back button is needed
    if (circularBackButton && appBar != null && _canPop(context)) {
      modifiedAppBar = _buildAppBarWithCircularBackButton(appBar!, context);
    }
    return Scaffold(
      backgroundColor: backgroundColor,
      drawer: drawer,
      appBar: modifiedAppBar,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: removePadding ? 0 : 18),
          child: GestureDetector(
            onTap: () =>
                isUnfocus == false ? {} : FocusScope.of(context).unfocus(),
            child: body,
          ),
        ),
      ),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  // Check if we can pop (back button is needed)
  bool _canPop(BuildContext context) {
    return Navigator.canPop(context);
  }

  AppBar _buildAppBarWithCircularBackButton(
    AppBar originalAppBar,
    BuildContext context,
  ) {
    return AppBar(
      leading: _buildCircularBackButton(context),
      automaticallyImplyLeading: false,
      title: originalAppBar.title,
      actions: originalAppBar.actions,
      flexibleSpace: originalAppBar.flexibleSpace,
      bottom: originalAppBar.bottom,
      elevation: originalAppBar.elevation,
      scrolledUnderElevation: originalAppBar.scrolledUnderElevation,
      shadowColor: originalAppBar.shadowColor,
      surfaceTintColor: originalAppBar.surfaceTintColor,
      backgroundColor: originalAppBar.backgroundColor,
      foregroundColor: originalAppBar.foregroundColor,
      iconTheme: originalAppBar.iconTheme,
      actionsIconTheme: originalAppBar.actionsIconTheme,
      primary: originalAppBar.primary,
      centerTitle: originalAppBar.centerTitle,
      excludeHeaderSemantics: originalAppBar.excludeHeaderSemantics,
      titleSpacing: originalAppBar.titleSpacing,
      toolbarOpacity: originalAppBar.toolbarOpacity,
      bottomOpacity: originalAppBar.bottomOpacity,
      toolbarHeight: originalAppBar.toolbarHeight,
      leadingWidth: originalAppBar.leadingWidth ?? backButtonSize + 16,
      toolbarTextStyle: originalAppBar.toolbarTextStyle,
      titleTextStyle: originalAppBar.titleTextStyle,
      systemOverlayStyle: originalAppBar.systemOverlayStyle,
    );
  }

  Widget _buildCircularBackButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.appBarIconColor),
        color: backButtonBackgroundColor ?? AppColors.appBarIconBG,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(Icons.arrow_back),
        color: backButtonIconColor ?? AppColors.appBarIconColor,
        iconSize: backButtonSize * 0.5,
        onPressed: () => Navigator.of(context).pop(),
        padding: EdgeInsets.zero,
        constraints: BoxConstraints(
          minWidth: backButtonSize,
          minHeight: backButtonSize,
        ),
      ),
    );
  }
}
