
enum AccuracyThresholdEnum {
  accuracyEasy(90),
  accuracyMedium(95),
  accuracyHigh(98);

  final double accuracy;
  const AccuracyThresholdEnum(this.accuracy);
}
