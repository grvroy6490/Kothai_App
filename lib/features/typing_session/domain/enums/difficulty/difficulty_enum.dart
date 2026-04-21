enum DifficultyEnum {
  easy,
  medium,
  hard,
}

extension DifficultyEnumSegmentLabel on DifficultyEnum {
  String get segmentLabel => switch (this) {
        DifficultyEnum.easy => 'Word',
        DifficultyEnum.medium => 'Sentence',
        DifficultyEnum.hard => 'Para',
      };
}