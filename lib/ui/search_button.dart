import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_search/bloc/github_search_bloc.dart';
import 'package:github_search/events/github_search_event.dart';
import 'package:github_search/repository/github_repository.dart';
import 'package:github_search/states/github_search_states.dart';
import 'package:github_search/ui/search_results.dart';


class SearchButton extends StatefulWidget {
  final GithubRepository githubRepository;

   const SearchButton({
    Key key,
    @required this.githubRepository,
  }) : super(key: key);

  @override
  _SearchButtonState createState() => _SearchButtonState();

}

class _SearchButtonState extends State<SearchButton> {
  GithubSearchBloc _githubSearchBloc;

  @override
  void initState() {
    _githubSearchBloc = GithubSearchBloc(
      githubRepository: widget.githubRepository
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
    return IconButton(
      icon: Icon(Icons.search),
      onPressed: () {
        print('hurray');
        showSearch(context: context, delegate: DataSearch(githubSearchBloc: _githubSearchBloc));
      },
    );
  }
}



class DataSearch extends SearchDelegate<String> {
  final recentCities = ['React', 'Angular', 'Javascript', 'Flutter'];
  GithubSearchBloc githubSearchBloc;

  DataSearch({ @required this.githubSearchBloc});
  
  @override
  List<Widget> buildActions(BuildContext context) {
    
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }
  
  @override
  Widget buildResults(BuildContext context) {
    githubSearchBloc.dispatch(
              TextChanged(text: query),
    );
    return Column(
      children: <Widget>[
        BlocBuilder<GithubSearchEvent, GithubSearchState>(
          bloc: githubSearchBloc,
          builder: (BuildContext context, GithubSearchState state) {
            if (state is SearchStateEmpty) {
              return Container(
                height: 500.0,
                alignment: Alignment.center,
                child: Text('Please enter a term to begin')
                );
            }
            if (state is SearchStateLoading) {
              return Container(
                height: 500.0,
                alignment:Alignment.center ,
                child: CircularProgressIndicator()
                );
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
        ),
      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = recentCities;
    

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          leading: Icon(Icons.location_city),
          title: Text(suggestionList[index]),
          onTap: (){
            githubSearchBloc.dispatch(
              TextChanged(text: query),
            );
          },
        );
      },
    );
  }
}

