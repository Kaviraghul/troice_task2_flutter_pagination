import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'movie.dart';

final movieServiceProvider = Provider<MovieService>((ref) {
  return MovieService(Dio());
});

class MovieService {
  MovieService( this._dio);

  final Dio _dio;

  Future<List<Movie>> getMovies([int page = 1]) async {

    final response = await _dio.get(
      "https://api.themoviedb.org/3/movie/popular?api_key=f7a7d0712c8ab39d13c7dc8e96d307fd&language=en-US&page=$page",
    );

    final results = List<Map<String, dynamic>>.from(response.data['results']);

    List<Movie> movies = results.map((movieData) => Movie.fromMap(movieData)).toList(growable: false);
    return movies;

  }
}
