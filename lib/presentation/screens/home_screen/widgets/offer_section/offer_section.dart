import 'dart:async';

import 'package:flutter/material.dart';
import 'package:freshOk/core/constants/measure.dart';
import 'package:freshOk/core/util/util.dart';
import 'package:freshOk/domain/entities/categories/category.dart';
import 'package:freshOk/domain/entities/categories/sub_category.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class OfferSection extends StatefulWidget {
  final Category category;

  const OfferSection({
    Key key,
    @required this.category,
  }) : super(key: key);

  @override
  _OfferSectionState createState() => _OfferSectionState();
}

class _OfferSectionState extends State<OfferSection> {
  PageController _pageController;
  Timer _timer;
  int idx = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(() {});
    _timer = Timer.periodic(new Duration(seconds: 50000), (Timer t) {
      if (widget.category.subContents[_pageController.page.toInt()].mediaType != 'video') {
        _pageController.animateToPage(
          (_pageController.page.toInt() + 1) % widget.category.subContents.length,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
        );
        setState(() {
          idx = (_pageController.page.toInt() + 1) % widget.category.subContents.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          width: measure.width,
          height: measure.width * (5 / 16),
          child: PageView(
            controller: _pageController,
            onPageChanged: (page) {
              setState(() {
                idx = page;
              });
              _timer.cancel();
              _timer = Timer.periodic(new Duration(seconds: 50000), (Timer t) {
                if (widget.category.subContents[_pageController.page.toInt()].mediaType != 'video') {
                  _pageController.animateToPage(
                    (_pageController.page.toInt() + 1) % widget.category.subContents.length,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                  );
                  setState(() {
                    idx = (_pageController.page.toInt() + 1) % widget.category.subContents.length;
                  });
                }
              });
            },
            children: _renderOfferCards(),
          ),
        ),
        Positioned(
          bottom: 10,
          child: Row(children: _renderDots()),
        )
      ],
    );
  }

  List<Widget> _renderDots() {
    List<Widget> list = List<Widget>();

    for (int i = 0; i < widget.category.subContents.length; ++i) {
      if (idx == i) {
        list.add(
          Padding(
            padding: EdgeInsets.all(2),
            child: CircleAvatar(radius: 3, backgroundColor: Colors.white),
          ),
        );
      } else {
        list.add(
          GestureDetector(
            onTap: () {
              _pageController.animateToPage(
                i,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
              );
            },
            child: Container(
              padding: EdgeInsets.all(2),
              color: Colors.transparent,
              child: Container(
                height: 6,
                width: 6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 1,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        );
      }
    }
    return list;
  }

  List<Widget> _renderOfferCards() {
    List<Widget> list = List<Widget>();
    widget.category.subContents.forEach((element) {
      list.add(OfferCard(
        banner: element,
        sectionId: widget.category.id,
        onVideoEnd: () {
          _pageController.animateToPage(
            (_pageController.page.toInt() + 1) % widget.category.subContents.length,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
          );
        },
      ));
    });
    return list;
  }
}

class OfferCard extends StatefulWidget {
  final SubCategory banner;
  final String sectionId;
  final onVideoEnd;
  const OfferCard({
    @required this.banner,
    @required this.onVideoEnd,
    @required this.sectionId,
  });

  @override
  _OfferCardState createState() => _OfferCardState();
}

class _OfferCardState extends State<OfferCard> {
  YoutubePlayerController _controller;

  @override
  void initState() {
    if (widget.banner.mediaType == 'video') {
      _controller = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(widget.banner.url),
        flags: YoutubePlayerFlags(
          autoPlay: true,
          mute: true,
          disableDragSeek: true,
          controlsVisibleAtStart: false,
          hideControls: true,
          enableCaption: false,
        ),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return GestureDetector(
      onTap: () {
        Util.subCategoryNavigationHandler(
          categoryId: widget.banner.value,
          idType: widget.banner.idType,
          sectionId: widget.sectionId,
          type: widget.banner.type,
          title: '',
        );
      },
      child: Container(
        width: measure.width,
        height: measure.width * (5 / 16),
        decoration: BoxDecoration(
          image: _renderImage(),
        ),
        child: _renderVideo(),
      ),
    );
  }

  Widget _renderVideo() {
    return widget.banner.mediaType == 'video'
        ? YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: false,
            aspectRatio: 16 / 5,
            onEnded: (metaData) {
              widget.onVideoEnd();
            },
          )
        : Container();
  }

  DecorationImage _renderImage() {
    //TODO : Correct image url
    return widget.banner.mediaType == 'image'
        ? DecorationImage(
            image: Image.asset('assets/test/App_Poster_1.jpg').image,
            fit: BoxFit.cover,
          )
        : null;
  }
}
