import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final Widget? leading;
  final double elevation;
  final Color? backgroundColor;
  final TextStyle? titleStyle;
  final double toolbarHeight;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBackButton = true,
    this.leading,
    this.elevation = 0,
    this.backgroundColor,
    this.titleStyle,
    this.toolbarHeight = kToolbarHeight,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: titleStyle ?? Theme.of(context).textTheme.titleLarge,
      ),
      leading: showBackButton
          ? leading ??
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () => Navigator.of(context).pop(),
              )
          : leading,
      actions: actions,
      elevation: elevation,
      backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.surface,
      toolbarHeight: toolbarHeight,
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight);
}