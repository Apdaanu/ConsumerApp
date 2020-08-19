import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freshOk/core/constants/measure.dart';
import 'package:freshOk/presentation/screens/recepie_screens/recepie_detail_screen/recepie_detail_bloc/recepie_detail_bloc.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class RecepieDetailVideoSection extends StatefulWidget {
  const RecepieDetailVideoSection({Key key}) : super(key: key);

  @override
  _RecepieDetailVideoSectionState createState() =>
      _RecepieDetailVideoSectionState();
}

class _RecepieDetailVideoSectionState extends State<RecepieDetailVideoSection> {
  YoutubePlayerController _controller;
  RecepieDetailBloc _recepieDetailBloc;

  @override
  void initState() {
    super.initState();
    _recepieDetailBloc = context.bloc<RecepieDetailBloc>();
    _controller = YoutubePlayerController(
      initialVideoId:
          YoutubePlayer.convertUrlToId(_recepieDetailBloc.recepie.video),
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        controlsVisibleAtStart: true,
        enableCaption: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Measure measure = MeasureImpl(context);
    return Container(
      color: Colors.grey,
      alignment: Alignment.center,
      child: YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: _controller,
        ),
        builder: (context, player) {
          return Column(
            children: [
              player,
            ],
          );
        },
      ),
    );
  }
}
