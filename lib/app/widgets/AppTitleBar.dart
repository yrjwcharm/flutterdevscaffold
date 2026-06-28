import 'package:flutter/material.dart';
import 'package:flutterdevscaffold/app/common/app_dimens.dart';

class AppTitleBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTitleBar({
    super.key,
    required this.title,
    this.centerTitle = true,
    this.backgroundColor = Colors.blue,
    this.titleTextStyle = const TextStyle(fontSize: 20, color: Colors.white),
    this.leading,
    this.actions,
    this.elevation = 0,
    this.automaticallyImplyLeading = true,
  });

  final Widget? title;
  final bool centerTitle;
  final Color backgroundColor;
  final TextStyle titleTextStyle;
  final Widget? leading;
  final List<Widget>? actions;
  final double elevation;
  final bool automaticallyImplyLeading;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      centerTitle: centerTitle,
      backgroundColor: backgroundColor,
      titleTextStyle: titleTextStyle,
      leading: leading,
      actions: actions,
      elevation: elevation,
      automaticallyImplyLeading: automaticallyImplyLeading,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(AppDimens.toolbarHeightSmall);
}
