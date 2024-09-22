import 'dart:developer';

import 'package:cbt_inbal/app/services/screen_type_service.dart';
import 'package:cbt_inbal/constants.dart';
import 'package:cbt_inbal/log_utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

class BottomPanel extends StatelessWidget {
  const BottomPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final padding = width * Constants.pageMarginPercent;
    final screenType = ScreenTypeService.getScreenType(width);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 5),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Constants.maximumWidth),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const FaIcon(
                      FontAwesomeIcons.instagram,
                      color: Colors.red,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const FaIcon(
                      FontAwesomeIcons.facebook,
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
              screenType == ScreenType.mobile
                  ? IconButton(
                      onPressed: _whatsAppTap,
                      icon: const FaIcon(
                        FontAwesomeIcons.whatsapp,
                        color: Colors.green,
                      ),
                    )
                  : TextButton.icon(
                      style: const ButtonStyle(
                        iconColor: WidgetStatePropertyAll(Colors.green),
                      ),
                      iconAlignment: IconAlignment.end,
                      onPressed: _whatsAppTap,
                      label: Text(
                        'שלח הודעה',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      icon: const FaIcon(
                        FontAwesomeIcons.whatsapp,
                        size: 30,
                      ),
                    ),
              Row(
                spacing: 2,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const FaIcon(FontAwesomeIcons.copyright, size: 10),
                  Text(
                    'Copyright 2024',
                    textDirection: TextDirection.ltr,
                    style: screenType == ScreenType.mobile
                        ? Theme.of(context).textTheme.labelLarge
                        : Theme.of(context).textTheme.bodyMedium,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _whatsAppTap() async {
    final msgEncoded = Uri.encodeComponent(Constants.whatsAppMessage);
    final whatsappUrl = 'https://wa.me/${Constants.phone}?text=$msgEncoded';

    if (await canLaunchUrlString(whatsappUrl)) {
      await launchUrlString(whatsappUrl);
    } else {
      logError("Could not open WhatsApp");
    }
  }
}
