import 'dart:math';

import 'package:flutter/material.dart';

import 'scroll_tile.dart';
import 'scroll_tile_direction.dart';

class ScrollTileWidget extends StatelessWidget {
  final ScrollTile tile;
  final Function(ScrollTile, ScrollTileDirection) processScroll;

  ScrollTileWidget(this.tile, this.processScroll, {Key? key}) : super(key: key);

  ScrollTileDirection? direction;

  @override
  Widget build(BuildContext context) {
    return tile.isCurrent
        ? GestureDetector(
            onVerticalDragStart: (dragDetails) => print('vertical drag start'),
            onHorizontalDragStart: (dragDetails) =>
                print('horizontal drag start'),
            onHorizontalDragUpdate: _processHorizontalDragUpdate,
            onVerticalDragUpdate: _processVerticalDragUpdate,
            onHorizontalDragEnd: _processHorizontalDragEnd,
            onVerticalDragEnd: _processVerticalDragEnd,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.green,
                border: Border.all(color: Colors.white, width: 1),
              ),
            ),
          )
        : Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.red,
              border: Border.all(color: Colors.white, width: 1),
            ),
          );
  }

  _processHorizontalDragUpdate(DragUpdateDetails dragDetails) {
    print('horizontal drag update - ${dragDetails.delta.direction}');
    if (dragDetails.delta.direction == pi) {
      direction = ScrollTileDirection.left;
      print('left');
    } else {
      direction = ScrollTileDirection.right;
      print('right');
    }
  }

  _processVerticalDragUpdate(DragUpdateDetails dragDetails) {
    print('vertical drag update - ${dragDetails.delta.direction}');
    if (dragDetails.delta.direction == pi / 2) {
      direction = ScrollTileDirection.down;
      print('down');
    } else {
      direction = ScrollTileDirection.up;
      print('up');
    }
  }

  _processVerticalDragEnd(DragEndDetails dragDetails) {
    print('vertical drag end');
    processScroll(tile, direction!);
    direction = null;
  }

  _processHorizontalDragEnd(DragEndDetails dragDetails) {
    print('horizontal drag end');
    processScroll(tile, direction!);
    direction = null;
  }
}
