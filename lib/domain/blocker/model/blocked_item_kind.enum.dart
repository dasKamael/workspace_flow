/// Whether a blocked entry refers to an application or a website.
///
/// The design derives this from the text: anything containing a dot is a site,
/// everything else an app.
enum BlockedItemKind {
  app,
  site;

  /// Classifies raw user input, as the prototype does.
  static BlockedItemKind fromInput(String raw) => raw.contains('.') ? BlockedItemKind.site : BlockedItemKind.app;
}
