enum JournalTheme {
  neoBrutalist,
  minimalist,
  journal,
  handDrawn,
  rubberHose;

  String get displayName {
    switch (this) {
      case JournalTheme.neoBrutalist:
        return 'NeoBrutalist';
      case JournalTheme.minimalist:
        return 'Minimalist';
      case JournalTheme.journal:
        return 'Klasik Günlük';
      case JournalTheme.handDrawn:
        return 'El Çizimi (Kraft)';
      case JournalTheme.rubberHose:
        return '1930s Rubber Hose';
    }
  }
}
