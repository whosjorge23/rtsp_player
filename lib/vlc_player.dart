import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vlc_flutter/vlcplayer.dart';

class CustomPlayerVLC extends StatefulWidget {
  @override
  _CustomPlayerVLCState createState() => _CustomPlayerVLCState();
}

class _CustomPlayerVLCState extends State<CustomPlayerVLC> {
  VLCController _controller = VLCController(args: ["-vvv"]);
  late bool _isplaying = true;
  bool _isFullScreen = false;
  @override
  void initState() {
    super.initState();
    _controller.onEvent.listen((event) {
      if (event.type == EventType.TimeChanged) {
        // debugPrint("==[${event.timeChanged}]==");
      }
    });

    _controller.onPlayerState.listen((state) {
      // debugPrint("--[$state]--");
    });

    load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  load() async {
    // rtmp://58.200.131.2:1935/livetv/natlgeo
    await _controller.setDataSource(
        uri:
            "rtsp://wowzaec2demo.streamlock.net/vod/mp4:BigBuckBunny_115k.mp4");
    _controller.play();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // appBar: AppBar(
        //   title: const Text('VLCPlayer Plugin example'),
        // ),
        body: Center(
          child: Stack(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: VLCVideoWidget(
                  controller: _controller,
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: 300,
                  color: Colors.white.withOpacity(0.5),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _isplaying
                            ? TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isplaying = false;
                                    _controller.pause();
                                  });
                                },
                                child: const Icon(
                                  Icons.pause,
                                  size: 30,
                                ),
                              )
                            : TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isplaying = true;
                                    _controller.play();
                                  });
                                },
                                child: Icon(
                                  Icons.play_arrow,
                                  size: 30,
                                ),
                              ),
                        // Expanded(
                        //   flex: 2,
                        //   child: SizedBox(
                        //     child: Slider(
                        //         value: double.parse(_vlcPlayerController
                        //             .value.position.inSeconds
                        //             .toString()),
                        //         max: double.parse(_vlcPlayerController
                        //             .value.duration.inSeconds
                        //             .toString()),
                        //         onChanged: (value) {
                        //           setState(() {
                        //             _vlcPlayerController
                        //                 .seekTo(Duration(seconds: value.toInt()));
                        //           });
                        //
                        //           // setState(() {});
                        //         }),
                        //   ),
                        // ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isFullScreen = !_isFullScreen;
                              if (_isFullScreen) {
                                SystemChrome.setPreferredOrientations([
                                  DeviceOrientation.landscapeLeft,
                                ]);
                              } else {
                                SystemChrome.setPreferredOrientations([
                                  DeviceOrientation.portraitUp,
                                ]);
                              }
                            });
                          },
                          child: Icon(
                            _isFullScreen
                                ? Icons.fullscreen_exit
                                : Icons.fullscreen,
                            size: 30,
                          ),
                        )
                      ]),
                ),
              ),
            ],
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
          //   children: [
          //     TextButton(
          //         child: Text("play"),
          //         onPressed: () async {
          //           _controller.play();
          //         }),
          //     TextButton(
          //         child: Text("pause"),
          //         onPressed: () {
          //           _controller.pause();
          //         }),
          //     TextButton(
          //         child: Text("stop"),
          //         onPressed: () {
          //           _controller.stop();
          //         }),
          //     TextButton(
          //         child: Text("startRecord"),
          //         onPressed: () {
          //           _controller.startRecord("/sdcard/test/");
          //         }),
          //     TextButton(
          //         child: Text("stopRecord"),
          //         onPressed: () {
          //           // _controller.stopRecord();
          //         })
          //   ],
          // )
        ),
      ),
    );
  }
}
