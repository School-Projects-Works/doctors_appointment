import 'package:doctors_appointment/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BarItem extends ConsumerStatefulWidget {
  const BarItem(
      {super.key,
      required this.title,
      required this.onTap,
      this.isActive = false,
      this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      this.icon});
  final String title;
  final VoidCallback onTap;
  final bool isActive;
  final IconData? icon;
  final EdgeInsetsGeometry padding;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BarItemState();
}

class _BarItemState extends ConsumerState<BarItem> {
  bool onHover = false;
  @override
  Widget build(BuildContext context) {
    var styles = Styles(context);
    return InkWell(
        onTap: widget.onTap,
        onHover: (value) {
          setState(() {
            onHover = value;
          });
        },
        child: Container(
            padding: widget.padding,
            decoration: BoxDecoration(
              border: widget.isActive
                  ? styles.smallerThanTablet
                      ? const Border(
                          left: BorderSide(color: Colors.white, width: 4))
                      : const Border(
                          bottom: BorderSide(color: Colors.white, width: 4))
                  : null,
            ),
            child: widget.icon != null
                ? Row(
                    children: [
                      Icon(
                        widget.icon,
                        color: widget.isActive
                            ? Colors.white
                            : onHover
                                ? Colors.white70
                                : Colors.white54,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        widget.title,
                        style: TextStyle(
                          color: widget.isActive
                              ? Colors.white
                              : onHover
                                  ? Colors.white70
                                  : Colors.white54,
                        ),
                      ),
                    ],
                  )
                : Text(
                    widget.title,
                    style: TextStyle(
                      color: widget.isActive
                          ? Colors.white
                          : onHover
                              ? Colors.white70
                              : Colors.white54,
                    ),
                  )));
  }
}
