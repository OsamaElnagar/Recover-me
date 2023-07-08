// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:recover_me/data/styles/colors.dart';
import 'package:recover_me/presentation/widgets/my_background_designs.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          if (_isExpanded) {
            _toggleExpanded();
          }
        },
        child: Stack(
          children: [
            // Your screen content goes here
            // ...
            Container(
              height: double.infinity,
              width: double.infinity,
              color: _isExpanded ? Colors.blueGrey.withOpacity(.6) : null,
              child: typeBackground(
                  child: const SizedBox(),
                  asset: 'assets/images/login-background.jpg',
                  context: context),
            ),
            Positioned(
              bottom: 30,
              right: 20,
              child: AnimatedContainer(
                margin: const EdgeInsets.all(0),
                duration: const Duration(milliseconds: 300),
                //width: 56,
                height: _isExpanded ? 250 : 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: _isExpanded ? Colors.grey.withOpacity(.5) : null,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (_isExpanded)
                        _buildExpandedButton(
                            label: 'Favorites',
                            icon: Icons.favorite_border_outlined,
                            onPressed: () {
                              // Do something when the first button is pressed
                            }),
                      if (_isExpanded) const SizedBox(width: 16),
                      if (_isExpanded)
                        _buildExpandedButton(
                            label: 'Share',
                            icon: Icons.share_outlined,
                            onPressed: () {
                              // Do something when the second button is pressed
                            }),
                      if (_isExpanded) const SizedBox(width: 16),
                      if (_isExpanded)
                        _buildExpandedButton(
                            label: 'Save',
                            icon: Icons.bookmark_border_outlined,
                            onPressed: () {
                              // Do something when the third button is pressed
                            }),
                      Padding(
                        padding: const EdgeInsets.only(right: 6.0),
                        child: FloatingActionButton(
                          backgroundColor:
                              _isExpanded ? Colors.transparent : Colors.blue,
                          elevation: _isExpanded ? 0.0 : 1.0,
                          onPressed: _toggleExpanded,
                          child: AnimatedIcon(
                            icon: AnimatedIcons.menu_close,
                            progress: _animationController,
                            size: _isExpanded ? 30.0 : 20.0,
                          ),
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
    );
  }

  Widget _buildExpandedButton({
    required IconData icon,
    required VoidCallback onPressed,
    required String label,
  }) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(1),
      margin: const EdgeInsets.only(
        left: 15,
        right: 5,
        top: 4,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              //backgroundColor: RecoverColors.myColor,
            ),
          ),
          const Spacer(),
          FloatingActionButton(
            elevation: 1,
            backgroundColor: RecoverColors.myColor,
            onPressed: onPressed,
            child: Icon(icon),
          ),
        ],
      ),
    );
  }
}

class MyScrollIndicator extends StatefulWidget {
  const MyScrollIndicator({super.key});

  @override
  _MyScrollIndicatorState createState() => _MyScrollIndicatorState();
}

class _MyScrollIndicatorState extends State<MyScrollIndicator> {
  final ScrollController _scrollController = ScrollController();
  double _scrollPosition = 0;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _scrollPosition = _scrollController.position.pixels;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: AppBar(
        title: const Text('Scroll Indicator'),
      ),
      body: Stack(
        children: [
          NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollUpdateNotification) {
                setState(() {
                  _scrollPosition = _scrollController.position.pixels;
                });
              }
              return false;
            },
            child: ListView.builder(
              controller: _scrollController,
              itemCount: 100,
              itemBuilder: (context, index) {
                currentIndex = index;
                return SizedBox(
                  height: 60.0,
                    child: Text('Item $index'));
              },
            ),
          ),
          Positioned(
            right: 0,
            top: currentIndex.toDouble() * 60.0,
            child: InkWell(
              onTap: () => setState(() {
                _scrollPosition = _scrollController.position.pixels;
              }),
              child: Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                width: 26,
                height: 50,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ScrollIndicatorPainter extends CustomPainter {
  final double scrollPosition;

  ScrollIndicatorPainter({required this.scrollPosition});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    const double indicatorHeight = 30.0;
    final double scrollFraction = scrollPosition / 500;

    final double top = scrollFraction * (size.height - indicatorHeight);

    canvas.drawRect(
      Rect.fromLTRB(0, top, size.width, top + indicatorHeight),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
