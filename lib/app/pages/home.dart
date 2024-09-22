import 'package:cbt_inbal/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      // width: 1600,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      constraints: const BoxConstraints(
        maxWidth: 2600,
        maxHeight: 2600,
      ),
      // height: double.infinity,
      child: Column(
        children: [
          const Spacer(),
          Text(
            Constants.homeFrontLabel1,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const Spacer(flex: 2),
          Text(
            Constants.homeFrontLabel3,
            style: Theme.of(context).textTheme.headlineMedium,
            maxLines: 3,
            textAlign: TextAlign.center,
          ),
          TextButton(
            onPressed: () {
              final controller = DefaultTabController.of(context);
              controller.animateTo(2);
            },
            child: const Text(
              'קראו עוד על CBT',
              style: TextStyle(fontSize: 20),
            ),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
