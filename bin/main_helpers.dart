part of 'main.dart';

final AlfredWorkflow _workflow = AlfredWorkflow(
  cache: AlfredCache<AlfredItems>(
    fromEncodable: (Map<String, dynamic> json) => AlfredItems.fromJson(json),
    maxEntries: 10240,
    expiryPolicy: const CreatedExpiryPolicy(
      Duration(days: 180),
    ),
  ),
);

final AlfredUpdater _updater = AlfredUpdater(
  githubRepositoryUrl: Uri.parse(Env.githubRepositoryUrl),
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

Future<void> _performSearch(String query) async {
  final AlgoliaQuerySnapshot snapshot = await AlgoliaSearch.query(query);

  if (snapshot.nbHits > 0) {
    final AlfredItems items = AlfredItems(
      await Future.wait(snapshot.hits
          .map((snapshot) => SearchResult.fromJson(snapshot.data))
          .map((result) async {
        final File? image = await EmojiDownloader(
          emoji: result.char,
        ).downloadImage();

        return AlfredItem(
          uid: result.objectID,
          title: result.shortName,
          subtitle: '${result.name}: ${result.keywords.join(', ')}',
          arg: result.char,
          match:
              '${result.shortName} ${result.name} ${result.keywords.join(', ')}',
          text: AlfredItemText(
            copy: result.char,
            largeType: result.name,
          ),
          icon: AlfredItemIcon(
            path: image != null ? image.absolute.path : 'question.png',
          ),
          valid: true,
        );
      }).toList()),
    );
    _workflow.addItems(items.items);
  } else {
    _workflow.addItem(
      AlfredItem(
        title: 'No matching emoji found',
        icon: AlfredItemIcon(path: 'question.png'),
      ),
    );
  }
}
