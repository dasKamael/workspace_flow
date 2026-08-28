import 'package:flutter/widgets.dart';

/// Kept out of `router.dart` so tests and utilities can reach the key without pulling
/// in every screen through the route table.
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
