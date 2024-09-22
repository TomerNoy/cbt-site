import 'dart:developer';

import 'package:cbt_inbal/app/providers/articles_provider.dart';
import 'package:cbt_inbal/app/providers/page_navigation_providers.dart';
import 'package:cbt_inbal/app/top_panel/on_hover_menu/on_hover_menu.dart';
import 'package:cbt_inbal/app/top_panel/on_hover_menu/on_hover_menu_item.dart';
import 'package:cbt_inbal/constants.dart';
import 'package:cbt_inbal/log_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MenuLong extends HookConsumerWidget {
  const MenuLong({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final articlesName = ref.watch(docsProvider.select((v) => v.articlesName));

    final isMenuOpen = ref.watch(menuOpenProvider);

    const mainTabNames = Constants.panelList;

    final itemController = useAnimationController(
      duration: const Duration(milliseconds: 300),
    );

    final fadeAnimation = CurvedAnimation(
      parent: itemController,
      curve: Curves.easeInOut,
    );

    useEffect(() {
      if (isMenuOpen) {
        itemController.reset();
        itemController.forward();
      } else {
        itemController.reverse();
      }
      return null;
    }, [isMenuOpen]);

    final hoveredMenu = MenuAnchorHovered(
      onOpen: () => ref.read(menuOpenProvider.notifier).openMenu(),
      onClose: () => ref.read(menuOpenProvider.notifier).closeMenu(),
      //articles button
      child: MenuAnchorHoveredItem(
        child: const _Label(name: 'מאמרים'),
        onPressed: () {
          DefaultTabController.of(context).index = 3;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final pageController = ref.read(articlePageProvider);
            if (pageController.hasClients) {
              ref.read(desiredPageIndexProvider.notifier).state = 0;
              pageController.jumpToPage(0);
            } else {
              logError('PageController not attached to any scroll views yet.');
            }
          });
        },
      ),
      // hovered menu
      items: List.generate(
        articlesName.length,
        (index) => MenuAnchorHoveredItem(
          child: FadeTransition(
            opacity: fadeAnimation,
            child: Container(
              color: Colors.white,
              width: 120,
              padding: const EdgeInsets.all(10),
              child: Text(
                articlesName[index],
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
          onPressed: () async {
            DefaultTabController.of(context).animateTo(3);
            ref.read(desiredPageIndexProvider.notifier).state = index + 1;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ref.read(articlePageProvider.notifier).setPage(index + 1);
            });
          },
        ),
      ),
    );

    final mainItems = List.generate(
      mainTabNames.length,
      (index) {
        return index == 3 && articlesName.isNotEmpty
            ? hoveredMenu
            : _PanelTab(index: index, name: mainTabNames[index]);
      },
    );

    return Container(
      constraints: const BoxConstraints(maxWidth: 450),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: mainItems,
      ),
    );
  }
}

class _PanelTab extends StatelessWidget {
  const _PanelTab({
    required this.index,
    required this.name,
  });

  final int index;
  final String name;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: _Label(name: name),
      onTap: () => DefaultTabController.of(context).index = index,
    );
  }
}

class _Label extends StatelessWidget {
  const _Label({
    required this.name,
  });
  final String name;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 90,
      height: 60,
      child: Text(
        name,
        style: Theme.of(context).textTheme.headlineSmall,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class MenuOpenNotifier extends StateNotifier<bool> {
  MenuOpenNotifier() : super(false);

  void openMenu() => state = true;
  void closeMenu() => state = false;
  void toggleMenu() => state = !state;
}

// Create the provider for the MenuOpenNotifier
final menuOpenProvider = StateNotifierProvider<MenuOpenNotifier, bool>(
  (ref) => MenuOpenNotifier(),
);
