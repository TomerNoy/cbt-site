import 'dart:developer';

import 'package:cbt_inbal/constants.dart';
import 'package:cbt_inbal/log_utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Contact extends StatelessWidget {
  const Contact({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final padding = width * Constants.pageMarginPercent;

    final fontStyle = Theme.of(context).textTheme.bodyLarge;

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: padding,
        right: padding,
        top: Constants.topPageSpace,
      ),
      child: Column(
        children: [
          Text(
            Constants.makeContact,
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 80),
          SizedBox(
            width: 350,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Column(
                children: [
                  ListTile(
                    dense: true,
                    title: Text(Constants.email, style: fontStyle),
                    leading: const FaIcon(
                      FontAwesomeIcons.envelope,
                      size: 30,
                      color: Colors.blue,
                    ),
                    trailing: Text(
                      'אימייל',
                      style: fontStyle,
                    ),
                    onTap: _emailTap,
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    title: Text(Constants.phone, style: fontStyle),
                    leading: const FaIcon(
                      FontAwesomeIcons.phone,
                      size: 30,
                    ),
                    trailing: Text(
                      'טלפון',
                      style: fontStyle,
                    ),
                    onTap: _phoneTap,
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    title: Text(Constants.whatsApp, style: fontStyle),
                    leading: const FaIcon(
                      FontAwesomeIcons.whatsapp,
                      size: 40,
                      color: Colors.green,
                    ),
                    trailing: Text(
                      'ווטסאפ',
                      style: fontStyle,
                    ),
                    onTap: _whatsAppTap,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _emailTap() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: Constants.email,
      query: 'subject=Hello&body=${Constants.whatsAppMessage}',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch $emailUri';
    }
  }

  void _phoneTap() async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: Constants.phone,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch ${Constants.phone}';
    }
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

class ContactRow extends StatelessWidget {
  const ContactRow({
    super.key,
    required this.icon,
    required this.label,
    required this.content,
    required this.onPressed,
  });

  final FaIcon icon;
  final String label;
  final String content;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton.icon(
            onPressed: onPressed,
            label: Text(label),
            icon: icon,
          ),
          Text(':$content'),
        ],
      ),
    );
  }
}
