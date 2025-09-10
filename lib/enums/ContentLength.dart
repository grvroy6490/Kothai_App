
enum ContentLength {
  short(100),
  medium(250),
  long(500);

  final int value;
  const ContentLength(this.value);
}
