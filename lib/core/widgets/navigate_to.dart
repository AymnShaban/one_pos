import 'package:flutter/cupertino.dart';

enum NavigationType { push, replace, clearStack }

void navigateTo(
  BuildContext context,
  Widget page, {
  NavigationType type = NavigationType.push,
}) {
  final route = CupertinoPageRoute(builder: (context) => page);

  switch (type) {
    case NavigationType.push:
      Navigator.push(context, route);
      break;

    case NavigationType.replace:
      Navigator.pushReplacement(context, route);
      break;

    case NavigationType.clearStack:
      Navigator.pushAndRemoveUntil(context, route, (route) => false);
      break;
  }
}
