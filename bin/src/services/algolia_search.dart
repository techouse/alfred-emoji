import 'package:algolia/algolia.dart'
    show Algolia, AlgoliaQuery, AlgoliaQuerySnapshot;

import '../env/env.dart';
import '../models/fitzpatrick.dart';
import '../models/search_result.dart';

class AlgoliaSearch {
  AlgoliaSearch._();

  static final Algolia _algolia = Algolia.init(
    applicationId: Env.algoliaApplicationId,
    apiKey: Env.algoliaSearchOnlyApiKey,
  );

  static Future<AlgoliaQuerySnapshot> query(
    String queryString, {
    Fitzpatrick? tone,
  }) async {
    final AlgoliaQuery query = _algolia.instance
        .index(Env.algoliaSearchIndex)
        .query(queryString)
        .setAttributesToRetrieve(SearchResult.attributesToRetrieve)
        .filters([
          if (tone != null) 'variants:$tone<score=1>',
          'variants:tone0<score=0>',
        ].join(' OR '))
        .setPage(0)
        .setHitsPerPage(20);

    return await query.getObjects();
  }
}
