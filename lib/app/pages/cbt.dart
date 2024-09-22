import 'package:cbt_inbal/app/providers/articles_provider.dart';
import 'package:cbt_inbal/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class CBT extends ConsumerWidget {
  const CBT({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    final padding = width * Constants.pageMarginPercent;

    final doc = ref.watch(docsProvider.select((v) => v.cbt));

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: padding,
        right: padding,
        top: Constants.topPageSpace,
      ),
      child: doc == null
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: ConstrainedBox(
                constraints:
                    const BoxConstraints(maxWidth: Constants.maximumWidth),
                child: HtmlWidget(
                  textStyle: Theme.of(context).textTheme.bodyLarge,
                  doc.content,
                  renderMode: RenderMode.column,
                ),
              ),
            ),
    );
  }
}
