import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
  }

  @override
  Widget build(BuildContext context) {
    double maxSlide = MediaQuery.of(context).size.width * 0.65;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return GestureDetector(
                onHorizontalDragUpdate: (details) {
                  double delta = details.primaryDelta! / maxSlide;
                  controller.value += delta;
                },
                onHorizontalDragEnd: (details) {
                  if (controller.isDismissed || controller.isCompleted) {
                    return;
                  }
                  if (details.primaryVelocity! > 0) {
                    controller.reverse();
                  } else {
                    controller.forward();
                  }
                },
                // onTap: () {
                //   if (controller.isDismissed) {
                //     controller.forward();
                //   } else {
                //     controller.reverse();
                //   }
                // },
                child: Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage('https://picsum.photos/200/300'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(maxWidth: maxSlide),
                      child: Transform.translate(
                        offset: Offset(maxSlide * (controller.value - 1), 0),
                        child: Transform(
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.001)
                              ..rotateY((1 - controller.value) * 3.14 / 2)
                            // ..translate(controller.value * maxSlide)
                            //
                            ,
                            alignment: Alignment.centerRight,
                            child: const Page1()),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(maxSlide * controller.value, 0),
                      child: Transform(
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(controller.value * -3.14 / 2)
                        // ..translate(controller.value * maxSlide)
                        //
                        ,
                        alignment: Alignment.centerLeft,
                        child: const Page2(),
                      ),
                    ),
                  ],
                ));
          }),
    );
  }
}

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.blue,
      ),
      child: const Center(
        child: Text(
          'Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}

class Page2 extends StatefulWidget {
  const Page2({super.key});

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.pink,
      ),
      child: const Center(
        child: Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}
