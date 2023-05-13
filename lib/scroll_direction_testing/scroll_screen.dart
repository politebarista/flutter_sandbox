import 'package:flutter/material.dart';

import 'scroll_tile.dart';
import 'scroll_tile_direction.dart';
import 'scroll_tile_position.dart';
import 'scroll_tile_widget.dart';

class ScrollScreen extends StatefulWidget {
  const ScrollScreen({Key? key}) : super(key: key);

  @override
  State<ScrollScreen> createState() => _ScrollScreenState();
}

class _ScrollScreenState extends State<ScrollScreen> {
  late final List<List<ScrollTile>> tiles;

  @override
  void initState() {
    tiles = [
      [
        ScrollTile(true),
        ScrollTile(false),
        ScrollTile(false),
      ],
      [
        ScrollTile(false),
        ScrollTile(false),
        ScrollTile(false),
      ],
      [
        ScrollTile(false),
        ScrollTile(false),
        ScrollTile(false),
      ]
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Text('testing scroll in grid'),
              // Expanded(
              //   child: GridView.count(
              //     crossAxisCount: 3,
              //     children: tiles.map((e) => ScrollTileWidget(e)).toList(),
              //   ),
              // ),
              ...tiles
                  .map(
                    (row) => Row(
                      children: [
                        ...row
                            .map((tile) =>
                                ScrollTileWidget(tile, _processScroll))
                            .toList(),
                      ],
                    ),
                  )
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }

  _processScroll(
    ScrollTile scrollTile,
    ScrollTileDirection scrollTileDirection,
  ) {
    print('scroll processing is started');

    final ScrollTilePosition currentTilePosition = _findTileByInstance(
      scrollTile,
    );

    switch (scrollTileDirection) {
      case ScrollTileDirection.right:
        if (tiles[currentTilePosition.x].length != currentTilePosition.y + 1) {
          setState(() {
            tiles[currentTilePosition.x][currentTilePosition.y].isCurrent = false;
            tiles[currentTilePosition.x][currentTilePosition.y + 1].isCurrent = true;
          });
        } else {
          print('rich boundaries at right');
        }
        break;
      case ScrollTileDirection.left:
        if (currentTilePosition.y != 0) {
          setState(() {
            tiles[currentTilePosition.x][currentTilePosition.y].isCurrent = false;
            tiles[currentTilePosition.x][currentTilePosition.y - 1].isCurrent = true;
          });
        } else {
          print('rich boundaries at left');
        }
        break;
      case ScrollTileDirection.down:
        if (tiles.length != currentTilePosition.x + 1) {
          setState(() {
            tiles[currentTilePosition.x][currentTilePosition.y].isCurrent = false;
            tiles[currentTilePosition.x + 1][currentTilePosition.y ].isCurrent = true;
          });
        } else {
          print('rich boundaries at bottom');
        }
        break;
      case ScrollTileDirection.up:
        if (currentTilePosition.x != 0) {
          setState(() {
            tiles[currentTilePosition.x][currentTilePosition.y].isCurrent = false;
            tiles[currentTilePosition.x - 1][currentTilePosition.y ].isCurrent = true;
          });
        } else {
          print('rich boundaries at top');
        }
        break;
      default:
        throw UnimplementedError();
    }
  }

  _findTileByInstance(ScrollTile scrollTile) {
    for (int i = 0; i < tiles.length; i++) {
      final List<ScrollTile> row = tiles[i];
      for (int j = 0; j < row.length; j++) {
        if (row[j] == scrollTile) {
          print('find correct tile at x - $i, y - $j');
          return ScrollTilePosition(i, j);
        }
      }
    }
    throw Error();
  }
}
