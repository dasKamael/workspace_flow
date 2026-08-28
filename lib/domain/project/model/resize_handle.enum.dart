/// Which grip of a window tile is being dragged.
///
/// The four corners move two edges at once, the four sides only one. Everything the
/// geometry needs is derived from the getters below, so resizing needs no switch.
enum ResizeHandle {
  topLeft,
  top,
  topRight,
  right,
  bottomRight,
  bottom,
  bottomLeft,
  left;

  bool get movesLeftEdge => this == topLeft || this == left || this == bottomLeft;

  bool get movesRightEdge => this == topRight || this == right || this == bottomRight;

  bool get movesTopEdge => this == topLeft || this == top || this == topRight;

  bool get movesBottomEdge => this == bottomLeft || this == bottom || this == bottomRight;

  /// A corner grip, drawn as the two 2px edges from the design.
  bool get isCorner => this == topLeft || this == topRight || this == bottomRight || this == bottomLeft;
}
