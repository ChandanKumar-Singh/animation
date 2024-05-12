import 'dart:math';
import 'dart:ui';

import 'package:anim1/setting_page.dart';
import 'package:flutter/material.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({
    super.key,
    required this.controller,
    required this.toogleDrawer,
    required this.maxWidth,
  });
  final AnimationController controller;
  final void Function() toogleDrawer;
  final double maxWidth;
  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage('https://picsum.photos/200/300'),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          constraints: BoxConstraints(maxWidth: widget.maxWidth),
          child: Theme(
            data: ThemeData(brightness: Brightness.dark),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 20, left: 10),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CircleAvatar(
                          radius: 35,
                          backgroundImage: NetworkImage(
                              'https://avatars.githubusercontent.com/u/57899051?v=4'),
                        ),
                        ListTile(
                          title: const Text('Dashboard'),
                          onTap: () {},
                        ),
                        ListTile(
                          title: const Text('Settings'),
                          onTap: () {
                            widget.toogleDrawer();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SettingPage()));
                          },
                        ),
                        Spacer(),
                        ListTile(
                          title: const Text('Logout'),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Logout'),
                                  content: const Text('Are you sure?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('No'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Yes'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),

                    /// close button
                    Positioned(
                      left: widget.maxWidth - 40,
                      child: Transform(
                        transform: Matrix4.identity()
                          ..scale(widget.controller.value)
                        // ..setEntry(3, 2, 0.001)
                        // ..rotateY(pi * widget.controller.value)
                        ,
                        child: Opacity(
                          opacity: widget.controller.value,
                          child: IconButton.filledTonal(
                            icon: const Icon(Icons.close),
                            onPressed: widget.toogleDrawer,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
