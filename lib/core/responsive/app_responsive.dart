
import 'package:flutter/material.dart';

class AppResponsive {
AppResponsive._();

// Breakpoints
static const double mobileBreakpoint = 600;
static const double tabletBreakpoint = 1024;

/// Screen width
static double width(BuildContext context) {
return MediaQuery.sizeOf(context).width;
}

/// Screen height
static double height(BuildContext context) {
return MediaQuery.sizeOf(context).height;
}

/// Mobile
static bool isMobile(BuildContext context) {
return width(context) < mobileBreakpoint;
}

/// Tablet
static bool isTablet(BuildContext context) {
final screenWidth = width(context);

return screenWidth >= mobileBreakpoint &&
screenWidth < tabletBreakpoint;
}

/// Desktop / Large screens
static bool isDesktop(BuildContext context) {
return width(context) >= tabletBreakpoint;
}

/// Mobile + Tablet
static bool isMobileOrTablet(BuildContext context) {
return width(context) < tabletBreakpoint;
}

/// Returns value based on device type
static T responsive<T>({
required BuildContext context,
required T mobile,
T? tablet,
T? desktop,
}) {
if (isMobile(context)) {
return mobile;
}

if (isTablet(context)) {
return tablet ?? mobile;
}

return desktop ?? tablet ?? mobile;
}
}

