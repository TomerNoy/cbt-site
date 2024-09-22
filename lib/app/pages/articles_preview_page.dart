import 'package:cbt_inbal/app/providers/articles_provider.dart';
import 'package:cbt_inbal/app/providers/page_navigation_providers.dart';
import 'package:cbt_inbal/constants.dart';
import 'package:cbt_inbal/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ArticlesPreviewPage extends ConsumerWidget {
  const ArticlesPreviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final articles = ref.watch(docsProvider).articles;
    final pageController = ref.watch(articlePageProvider);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Text(
            Constants.articleIntroduction,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 30),
          ...List.generate(
            articles.length,
            (index) {
              return GestureDetector(
                onTap: () {
                  if (pageController.hasClients) {
                    pageController.jumpToPage(index + 1);
                  }
                },
                child: Text(
                  articles[index].name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        decoration: TextDecoration.underline,
                      ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
