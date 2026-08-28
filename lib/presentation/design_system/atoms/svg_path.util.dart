import 'dart:typed_data';

import 'package:flutter/painting.dart';

/// Parses an SVG `d` attribute into a Flutter [Path].
///
/// Supports the subset the Heroicons set uses: `M m L l H h V v C c S s Q q T t A a Z z`.
/// This lets the icon paths be copied verbatim from the design instead of being
/// hand-translated into [Path] calls.
class SvgPathUtil {
  SvgPathUtil._();

  static final RegExp _command = RegExp('[a-zA-Z]');
  static final RegExp _number = RegExp(r'-?\d*\.?\d+(?:[eE][-+]?\d+)?');

  static Path parse(String d) {
    final path = Path();
    var current = Offset.zero;
    var start = Offset.zero;
    Offset? lastCubicControl;
    Offset? lastQuadraticControl;

    for (final token in _tokenize(d)) {
      final command = token.command;
      final args = token.args;
      final isRelative = command.toLowerCase() == command;
      Offset point(int i) => isRelative ? current + Offset(args[i], args[i + 1]) : Offset(args[i], args[i + 1]);

      switch (command.toUpperCase()) {
        case 'M':
          for (var i = 0; i + 1 < args.length; i += 2) {
            final p = point(i);
            if (i == 0) {
              path.moveTo(p.dx, p.dy);
              start = p;
            } else {
              path.lineTo(p.dx, p.dy);
            }
            current = p;
          }
          lastCubicControl = null;
          lastQuadraticControl = null;
        case 'L':
          for (var i = 0; i + 1 < args.length; i += 2) {
            final p = point(i);
            path.lineTo(p.dx, p.dy);
            current = p;
          }
          lastCubicControl = null;
          lastQuadraticControl = null;
        case 'H':
          for (final value in args) {
            current = Offset(isRelative ? current.dx + value : value, current.dy);
            path.lineTo(current.dx, current.dy);
          }
          lastCubicControl = null;
          lastQuadraticControl = null;
        case 'V':
          for (final value in args) {
            current = Offset(current.dx, isRelative ? current.dy + value : value);
            path.lineTo(current.dx, current.dy);
          }
          lastCubicControl = null;
          lastQuadraticControl = null;
        case 'C':
          for (var i = 0; i + 5 < args.length; i += 6) {
            final c1 = point(i);
            final c2 = point(i + 2);
            final end = point(i + 4);
            path.cubicTo(c1.dx, c1.dy, c2.dx, c2.dy, end.dx, end.dy);
            current = end;
            lastCubicControl = c2;
          }
          lastQuadraticControl = null;
        case 'S':
          for (var i = 0; i + 3 < args.length; i += 4) {
            final c1 = lastCubicControl == null ? current : current * 2 - lastCubicControl;
            final c2 = point(i);
            final end = point(i + 2);
            path.cubicTo(c1.dx, c1.dy, c2.dx, c2.dy, end.dx, end.dy);
            current = end;
            lastCubicControl = c2;
          }
          lastQuadraticControl = null;
        case 'Q':
          for (var i = 0; i + 3 < args.length; i += 4) {
            final c = point(i);
            final end = point(i + 2);
            path.quadraticBezierTo(c.dx, c.dy, end.dx, end.dy);
            current = end;
            lastQuadraticControl = c;
          }
          lastCubicControl = null;
        case 'T':
          for (var i = 0; i + 1 < args.length; i += 2) {
            final c = lastQuadraticControl == null ? current : current * 2 - lastQuadraticControl;
            final end = point(i);
            path.quadraticBezierTo(c.dx, c.dy, end.dx, end.dy);
            current = end;
            lastQuadraticControl = c;
          }
          lastCubicControl = null;
        case 'A':
          for (var i = 0; i + 6 < args.length; i += 7) {
            final end = isRelative ? current + Offset(args[i + 5], args[i + 6]) : Offset(args[i + 5], args[i + 6]);
            path.arcToPoint(
              end,
              radius: Radius.elliptical(args[i].abs(), args[i + 1].abs()),
              rotation: args[i + 2],
              largeArc: args[i + 3] != 0,
              clockwise: args[i + 4] != 0,
            );
            current = end;
          }
          lastCubicControl = null;
          lastQuadraticControl = null;
        case 'Z':
          path.close();
          current = start;
          lastCubicControl = null;
          lastQuadraticControl = null;
      }
    }

    return path;
  }

  /// Scales a path authored for [viewBox] (square) to fit [size] logical pixels.
  static Path scaled(String d, {required double viewBox, required double size}) {
    final factor = size / viewBox;
    return parse(d).transform(_scaleMatrix(factor));
  }

  /// A uniform scale matrix in the column-major layout [Path.transform] expects.
  static Float64List _scaleMatrix(double factor) => Float64List.fromList(<double>[
    factor, 0, 0, 0, //
    0, factor, 0, 0, //
    0, 0, 1, 0, //
    0, 0, 0, 1, //
  ]);

  static List<_PathToken> _tokenize(String d) {
    final tokens = <_PathToken>[];
    for (final match in _command.allMatches(d)) {
      final command = match.group(0)!;
      final nextIndex = _command.firstMatch(d.substring(match.end))?.start;
      final segment = nextIndex == null ? d.substring(match.end) : d.substring(match.end, match.end + nextIndex);
      final args = _number.allMatches(segment).map((m) => double.parse(m.group(0)!)).toList();

      // Arc flags are written without separators ("a4.5 4.5 0 10-9 0"): the "10" there is
      // largeArc=1 followed by sweep=0, not the number ten.
      tokens.add(_PathToken(command, command.toUpperCase() == 'A' ? _splitArcFlags(segment) : args));
    }
    return tokens;
  }

  /// Re-parses an arc segment, treating the two flag positions as single digits.
  static List<double> _splitArcFlags(String segment) {
    final values = <double>[];
    var index = 0;
    while (index < segment.length) {
      final position = values.length % 7;
      if (position == 3 || position == 4) {
        // Flag position: exactly one character, either '0' or '1'.
        final char = segment[index];
        if (char == '0' || char == '1') {
          values.add(char == '1' ? 1 : 0);
          index++;
          continue;
        }
        index++;
        continue;
      }
      final match = _number.matchAsPrefix(segment, index);
      if (match == null) {
        index++;
        continue;
      }
      values.add(double.parse(match.group(0)!));
      index = match.end;
    }
    return values;
  }
}

class _PathToken {
  const _PathToken(this.command, this.args);

  final String command;
  final List<double> args;
}
