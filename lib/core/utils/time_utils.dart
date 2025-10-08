String formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    final s = d.inSeconds % 60;

    if (h > 0) {
        return '${h}h ${m}m ${s}s';
    } else {
        return '${m}m ${s}s';
    }
}
