import 'dart:async';

import 'package:github_search/cache/github_cache.dart';
import 'package:github_search/data/github_client.dart';
import 'package:github_search/models/search_result.dart';

class GithubRepository {
  final GithubCache cache;
  final GithubClient client;

  GithubRepository(this.cache, this.client);

  Future<SearchResult> search(String term) async {
    if (cache.contains(term)) {
      return cache.get(term);
    } else {
      final result = await client.search(term);
      cache.set(term, result);
      return result;
    }
  }
}