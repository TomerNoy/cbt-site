import 'package:cbt_inbal/app/bottom_panel.dart';
import 'package:cbt_inbal/app/top_panel/menu_short.dart';
import 'package:cbt_inbal/app/pages/routes.dart';
import 'package:cbt_inbal/app/top_panel/top_panel.dart';
import 'package:cbt_inbal/constants.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      animationDuration: Duration.zero,
      length: Constants.panelList.length,
      child: const Scaffold(
        body: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                TopPanel(),
                Expanded(child: Routes()),
                BottomPanel(),
              ],
            ),
          ],
        ),
        endDrawer: MenuDrawer(),
      ),
    );
  }
}
