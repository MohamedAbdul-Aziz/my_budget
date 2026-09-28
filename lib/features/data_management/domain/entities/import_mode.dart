/// How a backup is applied to a phone that already has data.
enum ImportMode {
  /// Keep everything on the phone and add what is missing. Where a record
  /// exists in both, the newer change wins. Importing twice changes nothing.
  merge,

  /// Make the phone hold exactly what the backup holds. Only ever done after
  /// the user explicitly chooses it.
  replace,
}
