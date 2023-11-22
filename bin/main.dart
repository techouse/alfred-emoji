import 'dart:io' show File, exitCode, stdout;

import 'package:alfred_workflow/alfred_workflow.dart';
import 'package:algolia/algolia.dart';
import 'package:args/args.dart';
import 'package:cli_script/cli_script.dart';
import 'package:stash/stash_api.dart';

import 'src/env/env.dart';
import 'src/extensions/string_helpers.dart';
import 'src/models/fitzpatrick.dart';
import 'src/models/search_result.dart';
import 'src/services/algolia_search.dart';
import 'src/services/emoji_downloader.dart';

part 'main_helpers.dart';

bool _verbose = false;
bool _update = false;

void main(List<String> arguments) {
  wrapMain(() async {
    try {
      exitCode = 0;

      _workflow.clearItems();

      final ArgParser parser = ArgParser()
        ..addOption('query', abbr: 'q', defaultsTo: '')
        ..addFlag('verbose', abbr: 'v', defaultsTo: false)
        ..addFlag('update', abbr: 'u', defaultsTo: false);
      final ArgResults args = parser.parse(arguments);

      _update = args['update'];
      if (_update) {
        stdout.writeln('Updating workflow...');

        return await _updater.update();
      }

      _verbose = args['verbose'];

      final String query =
          args['query'].replaceAll(RegExp(r'\s+'), ' ').trim().toLowerCase();

      final Map? userDefaults = await _workflow.getUserDefaults();
      final int? toneIndex = int.tryParse(
        userDefaults?['alfred_emoji_skin_tone'] as String? ?? '',
      );
      late final Fitzpatrick? tone;

      if (toneIndex != null && toneIndex >= 1 && toneIndex <= 5) {
        try {
          tone = Fitzpatrick.values.elementAt(toneIndex - 1);
        } on RangeError {
          tone = null;
        }
      } else {
        tone = null;
      }

      if (_verbose) {
        stdout.writeln('Query: "$query"');
        if (tone != null) stdout.writeln('Tone: $tone');
      }

      if (query.isEmpty) {
        _showPlaceholder();
      } else {
        _workflow.cacheKey =
            tone != null ? '$query-$tone'.md5hex : query.md5hex;
        if (await _workflow.getItems() == null) {
          await _performSearch(
            query.toLowerCase(),
            tone: tone,
          );
        }
      }
    } on FormatException catch (err) {
      exitCode = 2;
      _workflow.addItem(AlfredItem(title: err.toString()));
    } catch (err) {
      exitCode = 1;
      _workflow.addItem(AlfredItem(title: err.toString()));
      if (_verbose) rethrow;
    } finally {
      if (!_update) {
        if (await _updater.updateAvailable()) {
          _workflow.run(addToBeginning: updateItem);
        } else {
          _workflow.run();
        }
      }
    }
  });
}
