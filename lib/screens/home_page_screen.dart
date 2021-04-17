import 'package:flutter/material.dart';
import 'package:flutter_movie_ticket_booking_app/common/color_constants.dart';
import 'package:flutter_movie_ticket_booking_app/model/movie_data.dart';
import 'package:flutter_movie_ticket_booking_app/screens/item_detail_screen.dart';
import 'package:flutter_movie_ticket_booking_app/widgets/app_widget.dart';

import 'package:flutter_movie_ticket_booking_app/widgets/text_button_widget.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

/*
Title: HomePageScreen
Purpose:HomePageScreen
Created By:Kalpesh Khandla
*/

class HomePageScreen extends StatefulWidget {
  HomePageScreen({
    Key key,
  }) : super(key: key);

  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen>
    with SingleTickerProviderStateMixin {
  var _movieData = MovieData();

  Size get _size => MediaQuery.of(context).size;

  double get _movieItemWidth => _size.width / 2 + 48;
  ScrollController _movieScrollController = ScrollController();
  ScrollController _backgroundScrollController = ScrollController();
  double _maxMovieTranslate = 65;
  int _movieIndex = 0;

  @override
  Widget build(BuildContext context) {
    _movieScrollController.addListener(
      () {
        _backgroundScrollController.jumpTo(
          _movieScrollController.offset * (_size.width / _movieItemWidth),
        );
      },
    );
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          _backgroundListView(),
          _movieListView(),
          TextButtonWidget(
            textColor: ColorConstants.kBlackColor,
            btnTxt: "Buy Ticket",
            btnBackColor: ColorConstants.kPrimaryColor,
            btnOnTap: () {
              print("object");
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (ctx, a1, a2) => ItemDetailScreen(
                    movie: _movieData.movieList[_movieIndex],
                    size: _size,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _movieItem(int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: <Widget>[
          AnimatedBuilder(
            animation: _movieScrollController,
            builder: (ctx, child) {
              double activeOffset = index * _movieItemWidth;

              double translate =
                  _movieTranslate(_movieScrollController.offset, activeOffset);

              return SizedBox(
                height: translate,
              );
            },
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image(
              image: _movieData.movieList[index].image.image,
              width: _size.width / 2,
            ),
          ),
          SizedBox(
            height: _size.height * .02,
          ),
          AnimatedBuilder(
            animation: _movieScrollController,
            builder: (context, child) {
              double activeOffset = index * _movieItemWidth;
              double opacity = _movieDescriptionOpacity(
                  _movieScrollController.offset, activeOffset);

              return Opacity(
                opacity: opacity / 100,
                child: Column(
                  children: <Widget>[
                    Text(
                      _movieData.movieList[index].name,
                      style: Theme.of(context).textTheme.caption.copyWith(
                            color: Colors.white,
                            fontSize: _size.width / 14,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    SizedBox(
                      height: _size.height * .01,
                    ),
                    AppWidget.genresFormat(
                      _movieData.movieList[index].genre,
                      Colors.white,
                    ),
                    SizedBox(
                      height: _size.height * .01,
                    ),
                    Text(
                      _movieData.movieList[index].rating.toString(),
                      style: Theme.of(context).textTheme.caption.copyWith(
                            color: Colors.white,
                            fontSize: _size.width / 16,
                          ),
                    ),
                    SizedBox(
                      height: _size.height * .005,
                    ),
                    AppWidget.starRating(
                      _movieData.movieList[index].rating,
                    )
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }

  double _movieDescriptionOpacity(double offset, double activeOffset) {
    double opacity;
    if (_movieScrollController.offset + _movieItemWidth <= activeOffset) {
      opacity = 0;
    } else if (_movieScrollController.offset <= activeOffset) {
      opacity =
          ((_movieScrollController.offset - (activeOffset - _movieItemWidth)) /
              _movieItemWidth *
              100);
    } else if (_movieScrollController.offset < activeOffset + _movieItemWidth) {
      opacity = 100 -
          (((_movieScrollController.offset - (activeOffset - _movieItemWidth)) /
                  _movieItemWidth *
                  100) -
              100);
    } else {
      opacity = 0;
    }
    return opacity;
  }

  double _movieTranslate(double offset, double activeOffset) {
    double translate;
    if (_movieScrollController.offset + _movieItemWidth <= activeOffset) {
      translate = _maxMovieTranslate;
    } else if (_movieScrollController.offset <= activeOffset) {
      translate = _maxMovieTranslate -
          ((_movieScrollController.offset - (activeOffset - _movieItemWidth)) /
              _movieItemWidth *
              _maxMovieTranslate);
    } else if (_movieScrollController.offset < activeOffset + _movieItemWidth) {
      translate =
          ((_movieScrollController.offset - (activeOffset - _movieItemWidth)) /
                  _movieItemWidth *
                  _maxMovieTranslate) -
              _maxMovieTranslate;
    } else {
      translate = _maxMovieTranslate;
    }
    return translate;
  }

  Widget _movieListView() {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 700),
      tween: Tween<double>(begin: 600, end: 0),
      curve: Curves.easeOutCubic,
      builder: (_, value, child) {
        return Transform.translate(
          offset: Offset(value, 0),
          child: child,
        );
      },
      child: Container(
        height: _size.height * .75,
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overScroll) {
            overScroll.disallowGlow();
            return true;
          },
          child: ScrollSnapList(
            listController: _movieScrollController,
            onItemFocus: (item) {
              _movieIndex = item;
            },
            itemSize: _movieItemWidth,
            padding: EdgeInsets.zero,
            itemCount: _movieData.movieList.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return _movieItem(index);
            },
          ),
        ),
      ),
    );
  }

  Widget _backgroundListView() {
    return ListView.builder(
      controller: _backgroundScrollController,
      padding: EdgeInsets.zero,
      reverse: true,
      itemCount: _movieData.movieList.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (ctx, index) {
        return Container(
          width: _size.width,
          height: _size.height,
          child: Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Positioned(
                left: -_size.width / 3,
                right: -_size.width / 3,
                child: Image(
                  image: _movieData.movieList[index].image.image,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                color: Colors.grey.withOpacity(.6),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(.9),
                      Colors.black.withOpacity(.3),
                      Colors.black.withOpacity(.95)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.1, 0.5, 0.9],
                  ),
                ),
              ),
              Container(
                height: _size.height * .25,
                padding:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: Align(
                  alignment: Alignment.center,
                  child: Image(
                    width: _size.width / 1.8,
                    image: _movieData.movieList[index].imageText.image,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
