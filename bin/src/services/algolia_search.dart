import 'package:algoliasearch/algoliasearch_lite.dart';

import '../env/env.dart';
import '../models/fitzpatrick.dart';
import '../models/search_result.dart';

class AlgoliaSearch {
  AlgoliaSearch._();

  static final SearchClient _client = SearchClient(
    appId: Env.algoliaApplicationId,
    apiKey: Env.algoliaSearchOnlyApiKey,
  );

  static Future<SearchResponse> query(
    String queryString, {
    Fitzpatrick? tone,
  }) =>
      _client.searchIndex(
        request: SearchForHits(
          indexName: Env.algoliaSearchIndex,
          query: queryString,
          attributesToRetrieve: SearchResult.attributesToRetrieve,
          filters: [
            if (tone != null) 'variants:$tone<score=1>',
            'variants:tone0<score=0>',
          ].join(' OR '),
          page: 0,
          hitsPerPage: 20,
        ),
      );

  static dispose() => _client.dispose();
}
