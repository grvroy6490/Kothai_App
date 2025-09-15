
enum XpMultiplier {
    easy(150),
    medium(250),
    hard(400);

    final int value;
    const XpMultiplier(this.value);
}


enum DifficultyMultiplier {
    easy(1.0),
    medium(1.2),
    hard(1.5);

    final double value;
    const DifficultyMultiplier(this.value);
}
