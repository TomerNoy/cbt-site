import 'dart:developer';

import 'package:cbt_inbal/app/providers/articles_provider.dart';
import 'package:cbt_inbal/app/providers/page_navigation_providers.dart';
import 'package:cbt_inbal/constants.dart';
import 'package:cbt_inbal/log_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MenuShort extends StatelessWidget {
  const MenuShort({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Scaffold.of(context).openEndDrawer(),
      icon: const FaIcon(FontAwesomeIcons.bars),
    );
  }
}

class MenuDrawer extends ConsumerWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final articlesName = ref.watch(docsProvider).articlesName;

    /// articles sub-menu
    var subMenu = articlesName.isEmpty
        ? const SizedBox.shrink()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              articlesName.length,
              (index) => SubMenuRow(index: index, name: articlesName[index]),
            ),
          );

    /// main menu
    final mainMenu = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 30,
        ),
        ...List.generate(
          Constants.panelList.length,
          (index) {
            return index == 3
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MainRow(index: index),
                      subMenu,
                    ],
                  )
                : MainRow(index: index);
          },
        )
      ],
    );

    return Drawer(child: mainMenu);
  }
}

/// main row
class MainRow extends ConsumerWidget {
  const MainRow({
    super.key,
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        DefaultTabController.of(context).animateTo(index);
        if (index == 3) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final pageController = ref.read(articlePageProvider);
            if (pageController.hasClients) {
              ref.read(desiredPageIndexProvider.notifier).state = 0;
              pageController.jumpToPage(0);
            } else {
              logError('PageController not attached to any scroll views yet.');
            }
          });
        }

        Navigator.of(context).pop();
      },
      child: Container(
        width: double.infinity,
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
        child: Text(
          Constants.panelList[index],
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}

/// sub menu row
class SubMenuRow extends ConsumerWidget {
  const SubMenuRow({
    super.key,
    required this.index,
    required this.name,
  });

  final int index;
  final String name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        DefaultTabController.of(context).animateTo(3);
        ref.read(desiredPageIndexProvider.notifier).state = index + 1;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(articlePageProvider.notifier).setPage(index + 1);
        });
        Navigator.of(context).pop();
      },
      child: Container(
        width: double.infinity,
        color: Colors.transparent,
        child: Padding(
          padding:
              const EdgeInsets.only(top: 5, bottom: 5, left: 30, right: 60),
          child: Row(
            children: [
              const Icon(Icons.circle, size: 10),
              const SizedBox(width: 5),
              Text(
                name,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
