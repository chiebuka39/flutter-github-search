import 'package:flutter/material.dart';
import 'package:github_search/cache/github_cache.dart';
import 'package:github_search/data/github_client.dart';
import 'package:github_search/repository/github_repository.dart';
import 'package:github_search/ui/search_form.dart';

void main() {
  final GithubRepository _githubRepository = GithubRepository(
    GithubCache(),
    GithubClient(),
  );

  runApp(App(githubRepository: _githubRepository));
}

class App extends StatelessWidget {
  final GithubRepository githubRepository;

  const App({
    Key key,
    @required this.githubRepository,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Github Search',
      home: Scaffold(
        appBar: AppBar(title: Text('Github Search')),
        body: SearchForm(
          githubRepository: githubRepository,
        ),
      ),
    );
  }
}
