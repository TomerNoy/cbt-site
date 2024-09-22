import 'package:cbt_inbal/app/services/screen_type_service.dart';
import 'package:cbt_inbal/app/top_panel/logo.dart';
import 'package:cbt_inbal/app/top_panel/menu_long.dart';
import 'package:cbt_inbal/app/top_panel/menu_short.dart';
import 'package:cbt_inbal/constants.dart';
import 'package:flutter/material.dart';

class TopPanel extends StatelessWidget {
  const TopPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenType = ScreenTypeService.getScreenType(screenWidth);
    final width = MediaQuery.of(context).size.width;
    final padding = width * Constants.pageMarginPercent;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: SizedBox(
        height: 150,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: Constants.maximumWidth),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: switch (screenType) {
                    ScreenType.web => const MenuLong(),
                    _ => const MenuShort(),
                  },
                ),
                const Logo(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
