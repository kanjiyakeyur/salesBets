sealed class Either<L, R> {
  const Either();
  factory Either.left(L l) => Left(l);
  factory Either.right(R r) => Right(r);

  T fold<T>(T Function(L) left, T Function(R) right) => switch (this) {
    Left(:final value) => left(value),
    Right(:final value) => right(value),
  };
  bool isLeft() => switch (this) {
    Left() => true,
    Right() => false,
  };
  bool isRight() => !isLeft();

  Either<L, T> mapRight<T>(T Function(R) f) => switch (this) {
    Left(:final value) => Left<L, T>(value),
    Right(:final value) => Right<L, T>(f(value)),
  };

  Either<T, R> mapLeft<T>(T Function(L) f) => switch (this) {
    Left(:final value) => Left<T, R>(f(value)),
    Right(:final value) => Right<T, R>(value),
  };
}

class Left<L, R> extends Either<L, R> {
  const Left(this._l);
  final L _l;
  L get value => _l;
}

class Right<L, R> extends Either<L, R> {
  const Right(this._r);
  final R _r;
  R get value => _r;
}
