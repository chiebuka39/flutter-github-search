import 'package:flutter/material.dart';


class SearchButton extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.search),
      onPressed: () {
        print('hurray');
        showSearch(context: context, delegate: DataSearch());
      },
    );
  }
}



class DataSearch extends SearchDelegate<String> {
  final recentCities = ['Lagos', 'Abuja', 'Jos', 'Akure'];
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
    return null;
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
        );
      },
    );
  }
}

