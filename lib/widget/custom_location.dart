import 'package:flutter/material.dart';
import 'package:pethhealth/constant/color.dart';
import 'package:url_launcher/url_launcher.dart';

class AnimatedLocationWidget extends StatefulWidget {
  final String imageLink;
  final String name1;
  final String name2;
  final String uriMap;

  AnimatedLocationWidget({
    required this.imageLink,
    required this.name1,
    required this.name2,
    required this.uriMap,
  });

  @override
  _AnimatedLocationWidgetState createState() => _AnimatedLocationWidgetState();
}

class _AnimatedLocationWidgetState extends State<AnimatedLocationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.7, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });

    _controller.forward();
  }

  Future<void> launchMap() async {
    String url = widget.uriMap;
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch Maps';
      }
    } catch (e) {
      // Handle error gracefully, e.g., show a snackbar with an error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: mainColor,
          content: Text('Could not open the map.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes the position of the shadow
          ),
        ],
      ),
      width: 160,
      height: 250,
      child: Column(
        children: [
          Text(
            widget.name1,
            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Image.asset(
              widget.imageLink,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              launchMap();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.name2,
                  style:
                      const TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 5),
                SlideTransition(
                  position: _animation,
                  child: const Icon(
                    Icons.navigate_next,
                    color: Colors.red,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
