import 'package:flutter_riverpod/all.dart';
import 'movie_service.dart';
import 'movies_pagination.dart';

final moviePaginationControllerProvider = StateNotifierProvider<MoviePaginationController>((ref) {
  final movieService = ref.read(movieServiceProvider);
  return MoviePaginationController(movieService);
});

class MoviePaginationController extends StateNotifier<MoviePagination> {
  MoviePaginationController(
      this._movieService, [
        MoviePagination state,
      ]) : super(state ?? MoviePagination.initial()) {
    getMovies();
  }

  final MovieService _movieService;

  Future<void> getMovies() async {

    final movies = await _movieService.getMovies(state.page);

    state = state.copyWith(movies: [...state.movies, ...movies], page: state.page + 1);
  }

  void handleScrollWithIndex(int index) {
    final itemPosition = index + 1;
    final requestMoreData = itemPosition % 20 == 0 && itemPosition != 0;
    final pageToRequest = itemPosition ~/ 20;
    if (requestMoreData && pageToRequest + 1 >= state.page) {
      getMovies();
    }
  }

}