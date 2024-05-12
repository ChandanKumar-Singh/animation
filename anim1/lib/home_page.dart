import 'dart:math';
import 'dart:ui';

import 'package:anim1/setting_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DashboardFragment extends StatefulWidget {
  const DashboardFragment(
      {super.key, required this.controller, required this.toogleDrawer});
  final AnimationController controller;
  final void Function() toogleDrawer;

  @override
  State<DashboardFragment> createState() => _DashboardStateFragment();
}

class _DashboardStateFragment extends State<DashboardFragment> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, child) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(widget.controller.value * 20),
          child: Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  Transform.translate(
                    offset: Offset(-20 * widget.controller.value, 0),
                    child: Opacity(
                      opacity: 1 - widget.controller.value,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: IconButton(
                          icon: const Icon(Icons.menu),
                          onPressed: widget.toogleDrawer,
                        ),
                      ),
                    ),
                  ),
                  const Expanded(child: Text('Dashboard Fragment')),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SettingPage())),
                ),
              ],
            ),
            body: Container(
              decoration: const BoxDecoration(
                color: Colors.pink,
              ),
              child: Stack(
                children: [
                  ListView.builder(
                    padding: const EdgeInsets.only(bottom: 150),
                    itemCount: 20,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {},
                        title: Text('Item $index'),
                      );
                    },
                  ),
                  const Sheet(),
                ],
              ),
            ),
            // bottomSheet: Sheet(),
          ),
        );
      },
    );
  }
}

class Sheet extends StatefulWidget {
  const Sheet({
    super.key,
  });

  @override
  State<Sheet> createState() => _SheetState();
}

class _SheetState extends State<Sheet> with SingleTickerProviderStateMixin {
  late final AnimationController animationController;

  double get maxHeight => MediaQuery.of(context).size.height - 100;
  double get minHeight => 150;
  double get headerHeight => 50;
  double get imageSmall => 50;
  double get imageBig => 120;
  double verticalSpace = 25;
  double horizontalSpace = 15;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    animationController.value -= details.primaryDelta! / maxHeight;
  }

  void _handleDragEnd(DragEndDetails details) {
    if (animationController.isAnimating ||
        animationController.status == AnimationStatus.completed) {
      return;
    }

    final double flingVelocity =
        details.velocity.pixelsPerSecond.dy / maxHeight;
    if (flingVelocity < 0) {
      animationController.fling(velocity: max(1.0, -flingVelocity));
    } else if (flingVelocity > 0) {
      animationController.fling(velocity: min(-1.0, -flingVelocity));
    } else {
      animationController.fling(
          velocity: animationController.value < 0.5 ? -1.0 : 1);
    }
  }

  double lerp(double min, double max) {
    return lerpDouble(min, max, animationController.value)!;
  }

  @override
  Widget build(BuildContext context) {
    int itemCount = 25;
    return AnimatedBuilder(
        animation: animationController,
        builder: (context, child) {
          return Positioned(
            height: lerp(120, maxHeight),
            left: 0,
            right: 0,
            bottom: 0,
            child: GestureDetector(
              onVerticalDragUpdate: _handleDragUpdate,
              onVerticalDragEnd: _handleDragEnd,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            right: 0,
                            top: lerp(20, 40),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'My Items',
                                  style: TextStyle(
                                    fontSize: lerp(15, 20),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    animationController.isCompleted
                                        ? Icons.keyboard_arrow_down
                                        : Icons.keyboard_arrow_up,
                                    size: lerp(20, 30),
                                  ),
                                  onPressed: () {
                                    if (animationController.isCompleted) {
                                      animationController.reverse();
                                    } else {
                                      animationController.forward();
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),

                          /// List of items
                          Positioned(
                            left: 0,
                            right: 0,
                            top: lerp(35, 80),
                            bottom: 0,
                            child: SingleChildScrollView(
                              padding: EdgeInsets.zero,
                              scrollDirection: animationController.isCompleted
                                  ? Axis.vertical
                                  : Axis.horizontal,
                              physics: animationController.isCompleted
                                  ? const BouncingScrollPhysics()
                                  : const PageScrollPhysics(),
                              // physics: BouncingScrollPhysics(),
                              child: Container(
                                height: (imageBig + verticalSpace) * itemCount,
                                width:
                                    (imageSmall + horizontalSpace) * itemCount +
                                        20 +
                                        verticalSpace,
                                child: Stack(
                                  children: [
                                    ...List.generate(
                                      itemCount,
                                      (index) => _ItemWidget(
                                        index: index,
                                        topMargin: lerp(
                                            20,
                                            (verticalSpace + imageBig) * index +
                                                10),
                                        leftMargin: lerp(
                                            (horizontalSpace + imageSmall) *
                                                index,
                                            20),
                                        imageSize: lerp(imageSmall, imageBig),
                                        isCompleted:
                                            animationController.isCompleted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class _ItemWidget extends StatelessWidget {
  const _ItemWidget({
    super.key,
    required this.index,
    required this.isCompleted,
    required this.topMargin,
    required this.leftMargin,
    required this.imageSize,
  });
  final int index;
  final bool isCompleted;
  final double topMargin;
  final double leftMargin;
  final double imageSize;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: topMargin,
      left: leftMargin,
      right: 0,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(imageSize * 0.1),
            child: Container(
              width: imageSize,
              height: imageSize,
              decoration: BoxDecoration(
                color: Colors.primaries[index % Colors.primaries.length],
                image: DecorationImage(
                  image: NetworkImage(
                      'https://media.licdn.com/dms/image/D4D12AQEcmDCdrpQqeQ/article-cover_image-shrink_720_1280/0/1692188714477?e=2147483647&v=beta&t=hU87YMMIjN1IO0RJQ4sF1Nx5hXbmvvm_21GNz9pSCZ0'),
                  // NetworkImage('https://picsum.photos/id/$index/200/300'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: isCompleted
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Item $index'),
                      Text('Description $index'),
                    ],
                  )
                : Container(),
          )
        ],
      ),
    );
  }
}
