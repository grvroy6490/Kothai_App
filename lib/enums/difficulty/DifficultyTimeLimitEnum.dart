enum DifficultyTimeLimit {
  limitEasy(Duration(minutes: 5, seconds: 0)),
  limitMedium(Duration(minutes: 4, seconds: 0)),
  limitHard(Duration(minutes: 3, seconds: 0));

  final Duration limit;
  const DifficultyTimeLimit(this.limit);
}
