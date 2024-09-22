import 'package:cbt_inbal/app/top_panel/on_hover_menu/on_hover_menu_item.dart';
import 'package:flutter/material.dart';

class MenuAnchorHovered extends StatefulWidget {
  const MenuAnchorHovered({
    super.key,
    required this.child,
    required this.items,
    this.exitOnTap = true,
    this.backgroundColor,
    this.childFocusNode,
    this.onClose,
    this.alignmentOffset,
    this.clipBehavior = Clip.hardEdge,
    this.consumeOutsideTap = false,
    this.crossAxisUnconstrained = true,
    this.style,
    this.onOpen,
  });

  final FocusNode? childFocusNode;
  final VoidCallback? onClose;
  final bool crossAxisUnconstrained;
  final Offset? alignmentOffset;
  final Clip clipBehavior;
  final bool consumeOutsideTap;

  final MenuAnchorHoveredItem child;
  final List<MenuAnchorHoveredItem> items;
  final bool exitOnTap;
  final WidgetStateProperty<Color?>? backgroundColor;
  final VoidCallback? onOpen;
  final MenuStyle? style;

  @override
  State<MenuAnchorHovered> createState() => _MenuAnchorHoveredState();
}

class _MenuAnchorHoveredState extends State<MenuAnchorHovered> {
  final GlobalKey widgetKey = GlobalKey();
  final MenuController _menuController = MenuController();

  late List<Widget> items;
  late MenuAnchorHoveredItem child;

  @override
  void initState() {
    items = List.generate(
      widget.items.length,
      (index) => GestureDetector(
        onTap: () {
          widget.items[index].onPressed?.call();

          if (widget.exitOnTap) _menuController.close();
        },
        child: MouseRegion(
          onEnter: (event) => _menuController.open(),
          onExit: (event) => _menuController.close(),
          child: widget.items[index].child,
        ),
      ),
    );
    child = widget.child;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        child.onPressed?.call();
        _menuController.isOpen
            ? _menuController.close()
            : _menuController.open();
      },
      child: MouseRegion(
        onEnter: (event) => _menuController.open(),
        onExit: (event) => _menuController.close(),
        child: MenuAnchor(
          childFocusNode: widget.childFocusNode,
          onClose: widget.onClose,
          alignmentOffset: widget.alignmentOffset,
          clipBehavior: widget.clipBehavior,
          consumeOutsideTap: widget.consumeOutsideTap,
          crossAxisUnconstrained: widget.crossAxisUnconstrained,
          onOpen: widget.onOpen,
          style: widget.style,
          controller: _menuController,
          key: widgetKey,
          menuChildren: items,
          child: child.child,
        ),
      ),
    );
  }
}
