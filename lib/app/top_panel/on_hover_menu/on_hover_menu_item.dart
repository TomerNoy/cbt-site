import 'package:flutter/material.dart';

class MenuAnchorHoveredItem {
  MenuAnchorHoveredItem({
    required this.child,
    this.onPressed,
  });

  final Widget child;
  final void Function()? onPressed;
}
