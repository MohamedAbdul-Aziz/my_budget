/// The kinds of file the user can export.
enum ExportFormat {
  /// Every record, restorable into the app (`.mybudget.json`).
  backup,

  /// Expenses and categories for Excel or Google Sheets (two `.csv` files).
  spreadsheet,

  /// A readable report of the expenses (`.pdf`). Not restorable.
  report,
}
