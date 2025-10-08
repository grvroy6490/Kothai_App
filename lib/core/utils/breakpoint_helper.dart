enum SizeClass { compact, medium, expanded }

SizeClass classify(double maxWidth) {
  if (maxWidth < 360) return SizeClass.compact;     // small phones
  if (maxWidth < 600) return SizeClass.medium;      // regular phones
  return SizeClass.expanded;                        // tablets/foldables
}
