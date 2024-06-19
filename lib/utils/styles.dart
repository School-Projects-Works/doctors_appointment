import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Styles {
  final BuildContext context;
  Styles(this.context);

  double get width => MediaQuery.of(context).size.width;
  double get height => MediaQuery.of(context).size.height;

  bool get isMobile => width < 768;
  bool get isTablet => width >= 768 && width < 1024;
  bool get isDesktop => width >= 1024;

  bool get smallerThanTablet => width < 1024;
  bool get largerThanTablet => width >= 1024;
  bool get largerThanMobile => width >= 768;

  bool get isPortrait => height > width;
  bool get isLandscape => width > height;

  Widget rowColumnWidget(List<Widget> children,
          {bool isRow = true,
          MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
          MainAxisSize mainAxisSize = MainAxisSize.max,
          CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
          EdgeInsetsGeometry padding = EdgeInsets.zero}) =>
      isRow
          ? Row(
              mainAxisAlignment: mainAxisAlignment,
              mainAxisSize: mainAxisSize,
              crossAxisAlignment: crossAxisAlignment,
              children: children,
            )
          : Column(
              mainAxisAlignment: mainAxisAlignment,
              mainAxisSize: mainAxisSize,
              crossAxisAlignment: crossAxisAlignment,
              children: children,
            );

  TextStyle title(
          {Color? color,
          FontWeight? fontWeight,
          double mobile = 20,
          double tablet = 25,
          double desktop = 30,
          String? fontFamily,
          FontStyle? style,
          double height = 1.5}) =>
      TextStyle(
          color: color ?? Colors.black,
          fontWeight: fontWeight ?? FontWeight.bold,
          fontFamily: fontFamily ?? 'OpenSans',
          fontStyle: style ?? FontStyle.normal,
          height: height,
          fontSize: isMobile
              ? mobile
              : isTablet
                  ? tablet
                  : desktop);

  TextStyle subtitle(
          {Color? color,
          FontWeight? fontWeight,
          double mobile = 15,
          double tablet = 20,
          double desktop = 25,
          String? fontFamily,
          FontStyle? style,
          double height = 1.5}) =>
      TextStyle(
          color: color ?? Colors.black,
          fontWeight: fontWeight ?? FontWeight.normal,
          fontFamily: fontFamily ?? 'OpenSans',
          fontStyle: style ?? FontStyle.normal,
          height: height,
          fontSize: isMobile
              ? mobile
              : isTablet
                  ? tablet
                  : desktop);

  TextStyle body(
          {Color? color,
          FontWeight? fontWeight,
          double mobile = 12,
          double tablet = 15,
          double desktop = 18,
          String? fontFamily,
          FontStyle? style,
          double height = 1.5}) =>
      TextStyle(
          color: color ?? Colors.black,
          fontWeight: fontWeight ?? FontWeight.normal,
          fontFamily: fontFamily ?? 'OpenSans',
          fontStyle: style ?? FontStyle.normal,
          height: height,
          fontSize: isMobile
              ? mobile
              : isTablet
                  ? tablet
                  : desktop);
}
