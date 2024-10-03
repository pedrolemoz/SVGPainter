sealed class Vector2d {
  final double _dx;
  final double _dy;

  const Vector2d(this._dx, this._dy);
}

class Offset extends Vector2d {
  const Offset(super.dx, super.dy);

  double get dx => _dx;
  double get dy => _dy;
}

class Size extends Vector2d {
  const Size(super.dx, super.dy);

  double get width => _dx;
  double get height => _dy;
}
