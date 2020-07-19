import 'package:flutter/material.dart';

import 'package:homeaccountantapp/const.dart';

class PointTabBar extends StatefulWidget {
  PointTabBar({
    Key key,
    this.tabController,
    this.length,
    this.tabsName
  });

  final TabController tabController;
  final int length;
  final List<String> tabsName;

  @override
  _PointTabBarState createState() => _PointTabBarState();
}


class _PointTabBarState extends State<PointTabBar> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return TabBar(
      indicator: CircleTabIndicator(color: baseColors.mainColor, radius: 3),
      indicatorColor: baseColors.mainColor,
      labelColor: baseColors.mainColor,
      controller: widget.tabController,
      tabs: List.generate(widget.tabsName.length, (int i) {
        return Tab(
          text: widget.tabsName[i],
        );
      })
    );
  }

}

class CircleTabIndicator extends Decoration {
  final BoxPainter _painter;

  CircleTabIndicator({@required Color color, @required double radius})
      : _painter = _CirclePainter(color, radius);

  @override
  BoxPainter createBoxPainter([onChanged]) => _painter;
}

class _CirclePainter extends BoxPainter {
  final Paint _paint;
  final double radius;

  _CirclePainter(Color color, this.radius)
      : _paint = Paint()
    ..color = color
    ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final Offset circleOffset =
        offset + Offset(cfg.size.width / 2, cfg.size.height - radius - 5);
    canvas.drawCircle(circleOffset, radius, _paint);
  }
}