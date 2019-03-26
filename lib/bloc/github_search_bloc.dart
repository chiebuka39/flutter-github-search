import 'package:bloc/bloc.dart';
import 'package:github_search/events/github_search_event.dart';
import 'package:github_search/models/search_result_error.dart';
import 'package:github_search/repository/github_repository.dart';
import 'package:github_search/states/github_search_states.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class GithubSearchBloc extends Bloc<GithubSearchEvent, GithubSearchState> {
  final GithubRepository githubRepository;

  GithubSearchBloc({@required this.githubRepository});

  @override
  Stream<GithubSearchEvent> transform(Stream<GithubSearchEvent> events) {
    return (events as Observable<GithubSearchEvent>)
        .debounce(Duration(milliseconds: 500));
  }

  @override
  void onTransition(
      Transition<GithubSearchEvent, GithubSearchState> transition) {
    print(transition.toString());
  }

  @override
  GithubSearchState get initialState => SearchStateEmpty();

  @override
  Stream<GithubSearchState> mapEventToState(
    GithubSearchEvent event,
  ) async* {
    if (event is TextChanged) {
      final String searchTerm = event.text;
      if (searchTerm.isEmpty) {
        yield SearchStateEmpty();
      } else {
        yield SearchStateLoading();
        try {
          final results = await githubRepository.search(searchTerm);
          yield SearchStateSuccess(results.items);
        } catch (error) {
          yield error is SearchResultError
              ? SearchStateError(error.message)
              : SearchStateError('something went wrong');
        }
      }
    }
  }
}