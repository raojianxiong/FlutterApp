import 'package:flutter/material.dart';
import 'package:flutter_app/movie/movie.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/detail/movie_detail_page.dart';

class MovieListPage extends StatefulWidget {
  @override
  MovieListPageState createState() => new MovieListPageState();
}

class MovieListPageState extends State<MovieListPage> {
  //这样写，相当于 = new List();
  List<Movie> movies = [];

  @override
  void initState() {
    super.initState();
    //初始化用于配置小部件，这里一进来，先请求接口也是OK的
    getMovieListData();
  }

  @override
  Widget build(BuildContext context) {
    var content;
    if (movies.isEmpty) {
      //为空，就转圈圈
      content = new Center(
        //默认的Circle,也可以显示文本之类的
          child: new CircularProgressIndicator()
      );
    } else {
      content = new ListView.builder(
          itemCount: movies.length,
          itemBuilder: buildMovieItem);
    }
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Jianxiong Rao 同学"),
          actions: <Widget>[
            new IconButton(
                icon: new Icon(Icons.person),
                onPressed: () {

                },
              tooltip: "Jianxiong Rao",
            )
          ],
        ),
        body: content
    );
  }

  //网络请求 async .... await 发送网络请求
  void getMovieListData() async {
    String response = await createHttpClient().read(
        'https://api.douban.com/v2/movie/in_theaters?%27%20%27apikey=0b2bdeda43b5688921839c8ecb20399b&city=%E5%A4%A9%E6%B4%A5&%27%20%27start=0&count=100&client=&udid=');
    //setState 相当于runOnUiThread ,调用的话，它会重新执行build方法
    setState(() {
      movies = Movie.allFromResponse(response);
    });
  }

  buildMovieItem(BuildContext context, int index) {
    Movie movie = movies[index];
    var movieImage = new Padding(padding: const EdgeInsets.only(
        left: 10.0,
        top: 10.0,
        right: 10.0,
        bottom: 10.0
    ),
      child: new Image.network(
        movie.smallImage,
        width: 100.0,
        height: 120.0,),);
    var movieMsg = new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      //如果要将子控件紧密包装在一起，则将其mainAxisSize设置为MainAxisSize.min
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        new Text(
            movie.title,
            textAlign: TextAlign.left,
            style: new TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.0
            )
        ),
        new Text('导演：' + movie.director),
        new Text('主演：' + movie.cast),
        new Text('评分：' + movie.average),
        new Text(
          movie.collectCount.toString() + "人看过",
          style: new TextStyle(
              fontSize: 12.0,
              color: Colors.redAccent
          ),
        )
      ],
    );

    var movieItem = new GestureDetector(
      //点击事件
      onTap: () => navigateToMovieDetailPage(movie, index),

      child: new Column(
        children: <Widget>[
          new Row(
            children: <Widget>[
              movieImage,
              //Expanded均分
              new Expanded(child: movieMsg),
              const Icon(Icons.keyboard_arrow_right)
            ],
          ),
          new Divider(),
        ],
      ),
    );
    return movieItem;
  }

  //跳转页面
  navigateToMovieDetailPage(Movie movie, Object imageTag) {
    Navigator
        .of(context)
        .push(new MaterialPageRoute(
        builder: (BuildContext context) {
          return new MovieDetailPage(movie, imageTag: imageTag);
        }
    ));
  }

}