import 'package:cbt_inbal/app/pages/about.dart';
import 'package:cbt_inbal/app/pages/articles_page.dart';
import 'package:cbt_inbal/app/pages/cbt.dart';
import 'package:cbt_inbal/app/pages/contact.dart';
import 'package:cbt_inbal/app/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Routes extends ConsumerWidget {
  const Routes({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const TabBarView(
      children: <Widget>[
        Home(),
        About(),
        CBT(),
        Articles(),
        Contact(),
      ],
    );
  }
}
