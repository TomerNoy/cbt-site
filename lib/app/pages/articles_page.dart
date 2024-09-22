import 'package:cbt_inbal/app/pages/articles_preview_page.dart';
import 'package:cbt_inbal/app/providers/articles_provider.dart';
import 'package:cbt_inbal/app/providers/page_navigation_providers.dart';
import 'package:cbt_inbal/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class Articles extends ConsumerWidget {
  const Articles({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    final padding = width * Constants.pageMarginPercent;

    final pageController = ref.watch(articlePageProvider);

    final articles = ref.watch(docsProvider).articles;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(
            left: padding,
            right: padding,
            top: Constants.topPageSpace,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: Constants.maximumWidth,
              ),
              child: PageView(
                controller: pageController,
                children: [
                  const ArticlesPreviewPage(),
                  ...articles.map((article) {
                    return HtmlWidget(
                      textStyle: Theme.of(context).textTheme.bodyLarge,
                      article.content,
                      renderMode: RenderMode.listView,
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
