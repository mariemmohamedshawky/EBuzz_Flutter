import 'package:ebuzz/components/maps/animation/ui_helper.dart';
import 'package:flutter/material.dart';

class RecentSearchWidget extends StatelessWidget {
  final double currentSearchPercent;

  const RecentSearchWidget({Key key, this.currentSearchPercent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return currentSearchPercent != 0
        ? Positioned(
            top: realH(
                -(75.0 + 494.0) + (75 + 75.0 + 494.0) * currentSearchPercent),
            left: realW((standardWidth - 320) / 2),
            width: realW(320),
            height: realH(494),
            child: Opacity(
              opacity: currentSearchPercent,
              child: Text('hello'),
            ),
          )
        : const Padding(
            padding: const EdgeInsets.all(0),
          );
  }
}
