import 'package:flutter/material.dart';

extension WidgetExtension on Widget {
  Widget addPadding() =>
      Padding(padding: const EdgeInsets.all(8.0), child: this);
}

