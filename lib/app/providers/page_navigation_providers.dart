import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final desiredPageIndexProvider = StateProvider<int>((ref) => 0);

final articlePageProvider =
    StateNotifierProvider<ArticlePageController, PageController>((ref) {
  final int desiredPageIndex = ref.watch(desiredPageIndexProvider);
  return ArticlePageController(desiredPageIndex);
});

class ArticlePageController extends StateNotifier<PageController> {
  ArticlePageController(int initialPage)
      : super(PageController(initialPage: initialPage));

  void setPage(int pageIndex) => state.jumpToPage(pageIndex);
}
