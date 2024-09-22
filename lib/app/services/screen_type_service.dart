enum ScreenType { web, tablet, mobile }

class ScreenTypeService {
  static ScreenType getScreenType(double width) {
    return switch (width) {
      <= 600 => ScreenType.mobile,
      >= 1024 => ScreenType.web,
      _ => ScreenType.tablet,
      // todo add support for small phones 320px?
    };
  }
}
