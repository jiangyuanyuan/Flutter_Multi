import 'package:flutter/cupertino.dart';

import 'package:flutterdemo/main.dart';
import 'package:flutterdemo/page/root_page.dart';

final routes = {
// tabbar
'/root': (context) => RootPage()

};

var onGenerateRoute = (RouteSettings settings) {
  // 统一处理
  final String? name = settings.name;
  final Function? pageContentBuilder = routes[name];
  if (pageContentBuilder != null) {
    if (settings.arguments != null) {
      final CupertinoPageRoute route = CupertinoPageRoute<Map<String, dynamic>>(
          builder: (context) =>
              pageContentBuilder(context, arguments: settings.arguments));
      return route;
    } else {
      final CupertinoPageRoute route =
      CupertinoPageRoute<Map<String, dynamic>>(builder: (context) => pageContentBuilder(context));
      return route;
    }
  }
};