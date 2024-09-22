import 'package:cbt_inbal/app/providers/articles_provider.dart';
import 'package:cbt_inbal/app/services/screen_type_service.dart';
import 'package:cbt_inbal/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class About extends ConsumerWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    final padding = width * Constants.pageMarginPercent;
    final screenType = ScreenTypeService.getScreenType(width);
    final about = ref.watch(docsProvider.select((v) => v.about));

    const gap = SizedBox(height: 30, width: 30);

    final image = ClipRRect(
      borderRadius: const BorderRadius.all(
        Radius.circular(25),
      ),
      child: Image.asset(
        'assets/images/inbal.jpeg',
        width: 400,
      ),
    );

    final text = HtmlWidget(
      textStyle: Theme.of(context).textTheme.bodyLarge,
      about?.content ?? '',
      renderMode: RenderMode.column,
    );

    return about == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : SingleChildScrollView(
            padding: EdgeInsets.only(
              left: padding,
              right: padding,
              top: Constants.topPageSpace,
            ),
            child: screenType == ScreenType.web
                ? Column(
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: Constants.maximumWidth,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: text),
                            gap,
                            image,
                          ],
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      image,
                      gap,
                      text,
                    ],
                  ),
          );
  }
}
