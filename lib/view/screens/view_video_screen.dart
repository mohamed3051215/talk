import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:chat_app/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class ViewViedeoScreen extends StatefulWidget {
  const ViewViedeoScreen({Key? key, required this.link}) : super(key: key);
  final String link;
  @override
  _ViewViedeoScreenState createState() => _ViewViedeoScreenState(link);
}

class _ViewViedeoScreenState extends State<ViewViedeoScreen>
    with SingleTickerProviderStateMixin {
  _ViewViedeoScreenState(this.link);

  final String link;
  late VideoPlayerController _controller;
  bool loading = true;
  bool playing = false;
  int seconds = 0;
  late AnimationController _animationController;
  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _controller = VideoPlayerController.network(link)
      ..initialize().then((_) {
        setState(() {
          loading = false;
        });
        setState(() {});
      })
      ..setLooping(true)
      ..addListener(() {
        setState(() {
          seconds = _controller.value.position.inSeconds;
        });
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: BackButton(
            color: lightPurple,
            onPressed: () {
              Get.back();
            },
          ),
        ),
        body: Stack(alignment: Alignment.center, children: [
          Center(
            child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: VideoPlayer(_controller),
                    ),
                    Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                            padding: EdgeInsets.all(8),
                            color: Colors.black.withOpacity(.4),
                            child: ProgressBar(
                              progress: Duration(
                                seconds: _controller.value.position.inSeconds,
                              ),
                              total: _controller.value.duration,
                              progressBarColor: lightPurple,
                              baseBarColor: Colors.white.withOpacity(0.24),
                              bufferedBarColor: Colors.white.withOpacity(0.24),
                              thumbColor: Colors.white,
                              barHeight: 3.0,
                              thumbRadius: 5.0,
                              onSeek: (duration) {
                                _controller.seekTo(duration);
                              },
                              thumbCanPaintOutsideBar: true,
                              timeLabelLocation: TimeLabelLocation.sides,
                              timeLabelTextStyle: TextStyle(color: lightPurple),
                            )))
                  ],
                )),
          ),
          !loading
              ? Positioned(
                  child: InkWell(
                  onTap: () {
                    !playing
                        ? _animationController.forward()
                        : _animationController.reverse();
                    !playing ? _controller.play() : _controller.pause();
                    playing = !playing;
                  },
                  child: AnimatedIcon(
                      icon: AnimatedIcons.play_pause,
                      progress: _animationController,
                      size: 80,
                      color: lightPurple),
                ))
              : CircularProgressIndicator(
                  color: lightPurple,
                ),
        ]));
  }
// ProgressBar(
  // progress: Duration(
  //   seconds: _controller.value.position.inSeconds,
  // ),
//                   total: _controller.value.duration,
//                   progressBarColor: lightPurple,
//                   baseBarColor: Colors.black.withOpacity(.2),
//                 ),
}
