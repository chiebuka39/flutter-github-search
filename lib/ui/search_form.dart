import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:url_launcher/url_launcher.dart';
import 'package:github_search/bloc/github_search_bloc.dart';
import 'package:github_search/events/github_search_event.dart';
import 'package:github_search/models/search_result_item.dart';
import 'package:github_search/repository/github_repository.dart';
import 'package:github_search/states/github_search_states.dart';
import 'package:github_search/ui/search_results.dart';


class SearchForm extends StatefulWidget {
  final GithubRepository githubRepository;

  const SearchForm({
    Key key,
    @required this.githubRepository,
  }) : super(key: key);

  @override
  _SearchFormState createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  GithubSearchBloc _githubSearchBloc;

  @override
  void initState() {
    _githubSearchBloc = GithubSearchBloc(
      githubRepository: widget.githubRepository,
    );
    super.initState();
  }

  @override
  void dispose() {
    _githubSearchBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _SearchBar(githubSearchBloc: _githubSearchBloc),
        _SearchBody(githubSearchBloc: _githubSearchBloc)
      ],
    );
  }
}



class _SearchBar extends StatefulWidget {
  final GithubSearchBloc githubSearchBloc;

  _SearchBar({Key key, this.githubSearchBloc}) : super(key: key);

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  final _textController = TextEditingController();

  GithubSearchBloc get githubSearchBloc => widget.githubSearchBloc;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textController,
      autocorrect: false,
      onChanged: (text) {
        githubSearchBloc.dispatch(
          TextChanged(text: text),
        );
      },
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search),
        suffixIcon: GestureDetector(
          child: Icon(Icons.clear),
          onTap: _onClearTapped,
        ),
        border: InputBorder.none,
        hintText: 'Enter a search term',
      ),
    );
  }

  void _onClearTapped() {
    _textController.text = '';
    githubSearchBloc.dispatch(TextChanged(text: ''));
  }
}


class _SearchBody extends StatelessWidget {
  final GithubSearchBloc githubSearchBloc;

  const _SearchBody({Key key, this.githubSearchBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GithubSearchEvent, GithubSearchState>(
      bloc: githubSearchBloc,
      builder: (BuildContext context, GithubSearchState state) {
        if (state is SearchStateEmpty) {
          return Text('Please enter a term to begin');
        }
        if (state is SearchStateLoading) {
          return CircularProgressIndicator();
        }
        if (state is SearchStateError) {
          return Text(state.error);
        }
        if (state is SearchStateSuccess) {
          return state.items.isEmpty
              ? Text('No Results')
              : Expanded(child: SearchResults(items: state.items));
        }
      },
    );
  }
}


