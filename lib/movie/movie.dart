import 'package:meta/meta.dart';
import 'dart:convert';

class Movie {
  final String title;
  final String average; //此字段解析出来不是String类型
  final int collectCount;
  final String smallImage;
  final String director;
  final String cast;
  final String movieId;

  Movie({@required this.title,
    @required this.average,
    @required this.collectCount,
    @required this.smallImage,
    @required this.director,
    @required this.cast,
    @required this.movieId,});

  static List<Movie> allFromResponse(String json) {
    //utf-8格式
    return JSON.decode(json)['subjects']
        .map((it) => Movie.fromMap(it))
        .toList();
  }

  static Movie fromMap(Map map) {
    List directors = map['directors'];
    List casts = map['casts'];
    //导演名，可能有一个或多个导演
    var d = '';
    for (int i = 0; i < directors.length; i++) {
      if (i == 0) {
        d = d + directors[i]['name'];
      } else {
        d = d + '/' + directors[i]['name'];
      }
    }
    //主演,也是可能有一个或多个演员
    var c = '';
    for (int i = 0; i < casts.length; i++) {
      if (i == 0) {
        c = c + casts[i]['name'];
      } else {
        c = c + '/' + casts[i]['name'];
      }
    }
    return new Movie(title: map['title'],
        average: map['rating']['average'].toString(),
        collectCount: map['collect_count'],
        smallImage: map['images']['small'],
        director: d,
        cast: c,
        movieId: map['id']);
  }
}