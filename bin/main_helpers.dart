part of 'main.dart';

final AlfredWorkflow _workflow = AlfredWorkflow(
  cache: AlfredCache<AlfredItems>(
    fromEncodable: (Map<String, dynamic> json) => AlfredItems.fromJson(json),
    maxEntries: 10240,
    expiryPolicy: const CreatedExpiryPolicy(
      Duration(days: 7),
    ),
  ),
)..disableAlfredSmartResultOrdering = true;

final AlfredUpdater _updater = AlfredUpdater(
  githubRepositoryUrl: Env.githubRepositoryUrl,
  currentVersion: Env.appVersion,
  updateInterval: Duration(days: 7),
);

const updateItem = AlfredItem(
  title: 'Auto-Update available!',
  subtitle: 'Press <enter> to auto-update to a new version of this workflow.',
  arg: 'update:workflow',
  match:
      'Auto-Update available! Press <enter> to auto-update to a new version of this workflow.',
  icon: AlfredItemIcon(path: 'alfredhatcog.png'),
  valid: true,
);

void _showPlaceholder() {
  _workflow.addItem(
    const AlfredItem(
      title: 'Search for emojis ...',
      icon: AlfredItemIcon(path: 'icon.png'),
    ),
  );
}

Future<void> _performSearch(
  String query, {
  Fitzpatrick? tone,
}) async {
  final AlgoliaQuerySnapshot snapshot = await AlgoliaSearch.query(
    query,
    tone: tone,
  );

  if (snapshot.nbHits > 0) {
    _workflow.addItems(await Future.wait(snapshot.hits
        .map((AlgoliaObjectSnapshot snapshot) =>
            SearchResult.fromJson(snapshot.data))
        .map((SearchResult emoji) async {
      final File? image =
          await EmojiDownloader(emoji: emoji.char).downloadImage();

      return AlfredItem(
        uid: emoji.objectID,
        title: emoji.name,
        subtitle: '${emoji.char} :${emoji.shortName}:',
        arg: emoji.char,
        match: '${emoji.shortName} ${emoji.name} ${emoji.keywords.join(', ')}',
        text: AlfredItemText(
          copy: emoji.char,
          largeType: emoji.name,
        ),
        quickLookUrl:
            Uri.https('emojipedia.org', 'emoji/${emoji.char}/').toString(),
        icon: AlfredItemIcon(path: image?.absolute.path ?? 'question.png'),
        mods: {
          {AlfredItemModKey.alt}: AlfredItemMod(
            subtitle: 'Copy ":${emoji.shortName}:" to clipboard',
            arg: ':${emoji.shortName}:',
            icon: AlfredItemIcon(path: image?.absolute.path ?? 'question.png'),
          ),
          {AlfredItemModKey.shift}: AlfredItemMod(
            subtitle: 'Copy Python source of "${emoji.char}" to clipboard',
            arg: 'u"\\U000'
                '${emoji.char.runes.first.toRadixString(16).toUpperCase()}'
                '${emoji.char.runes.toList().sublist(1).map(
                      (int i) => '\\u${i.toRadixString(16).toUpperCase()}',
                    ).join()}"',
            icon: AlfredItemIcon(path: image?.absolute.path ?? 'question.png'),
          ),
          {AlfredItemModKey.ctrl}: AlfredItemMod(
            subtitle: 'Copy HTML Entity of "${emoji.char}" to clipboard',
            arg: emoji.char.runes
                .map((int i) => '&#x${i.toRadixString(16)};')
                .join(),
            icon: AlfredItemIcon(path: image?.absolute.path ?? 'question.png'),
          ),
          {AlfredItemModKey.ctrl, AlfredItemModKey.shift}: AlfredItemMod(
            subtitle:
                'Copy formal Unicode notation of "${emoji.char}" to clipboard',
            arg: emoji.char.runes
                .map((int i) => 'U+${i.toRadixString(16).toUpperCase()}')
                .join(', '),
            icon: AlfredItemIcon(path: image?.absolute.path ?? 'question.png'),
          ),
        },
        valid: true,
      );
    }).toList()));
  } else {
    _workflow.addItem(
      AlfredItem(
        title: 'No matching emoji found',
        icon: AlfredItemIcon(path: 'question.png'),
      ),
    );
  }
}
