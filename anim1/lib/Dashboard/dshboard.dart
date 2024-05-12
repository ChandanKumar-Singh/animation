import 'package:anim1/Dashboard/drawer.dart';
import 'package:anim1/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  void toogleDrawer() {
    if (_controller.isDismissed) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    double maxSlide = w * 0.65;
    double minScale = 0.7;
    return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Scaffold(
            // backgroundColor: Colors.teal,
            body: GestureDetector(
              onHorizontalDragUpdate: (details) {
                double delta = details.primaryDelta! / maxSlide;
                _controller.value += delta;
              },
              onHorizontalDragEnd: (details) {
                if (_controller.isDismissed || _controller.isCompleted) {
                  return;
                }
                if (details.primaryVelocity! > 0) {
                  _controller.reverse();
                } else {
                  _controller.forward();
                }
              },
              // onTap: toogleDrawer,
              child: Stack(
                children: [
                  DrawerWidget(
                      controller: _controller,
                      toogleDrawer: toogleDrawer,
                      maxWidth: maxSlide - 20),
                  Transform(
                    transform: Matrix4.identity()
                      ..translate(_controller.value * maxSlide,
                          h * _controller.value * ((1 - minScale) / 2), 0)
                      ..scale(1 - (_controller.value * (1 - minScale)))
                    // ..rotateZ(_controller.value * 0.5)
                    ,
                    child: AnimatedContainer(
                      duration: _controller.duration!,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: AbsorbPointer(
                        absorbing: !_controller.isDismissed,
                        child: DashboardFragment(
                          controller: _controller,
                          toogleDrawer: toogleDrawer,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
