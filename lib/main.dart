import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:rtsp_player/custom_player.dart';
import 'package:rtsp_player/vlc_player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late bool _isplaying = true;
  VlcPlayerController? _vlcPlayerController;
  bool _isFullScreen = false;
  double playbackValue = 0.0;

  @override
  void dispose() async {
    super.dispose();
    await _vlcPlayerController?.stopRendererScanning();
    await _vlcPlayerController?.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _vlcPlayerController = VlcPlayerController.network(
      "rtsp://wowzaec2demo.streamlock.net/vod/mp4:BigBuckBunny_115k.mp4",
      hwAcc: HwAcc.full,
      autoPlay: true,
      options: VlcPlayerOptions(),
    );
    _vlcPlayerController!.addListener(() {
      setState(() {
        playbackValue =
            _vlcPlayerController!.value.position.inSeconds.toDouble();
      });
    });
  }

  // void checkVideo() {
  //   // Implement your calls inside these conditions' bodies :
  //   if (_vlcPlayerController?.value.position ==
  //       Duration(seconds: 0, minutes: 0, hours: 0)) {
  //     // print('video Started');
  //   }
  //
  //   // print(
  //   //     "Position: ${double.parse(_vlcPlayerController.value.position.inSeconds.toString())}");
  //   // print(
  //   //     "End: ${double.parse(_vlcPlayerController.value.duration.inSeconds.toString())}");
  //
  //   if (_vlcPlayerController?.value.position ==
  //       _vlcPlayerController?.value.duration) {
  //     // print('video Ended');
  //   }
  //
  //   playbackValue =
  //       double.parse(_vlcPlayerController!.value.position.inSeconds.toString());
  // }

  void showModal() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomPlayer(
          url:
              "rtsp://wowzaec2demo.streamlock.net/vod/mp4:BigBuckBunny_115k.mp4",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () {
            showModal();
          },
          child: Text("Button"),
        ),
      ),
    );
  }

  Center buildRTPSPlayer(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          VlcPlayer(
            controller: _vlcPlayerController!,
            aspectRatio: 16 / 9,
            placeholder: Center(
              child: CircularProgressIndicator(),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: _isFullScreen
                  ? MediaQuery.of(context).size.width / 1.2
                  : MediaQuery.of(context).size.width,
              color: Colors.white.withOpacity(0.5),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                _isplaying
                    ? TextButton(
                        onPressed: () {
                          setState(() {
                            _isplaying = false;
                            _vlcPlayerController?.pause();
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
                            _vlcPlayerController?.play();
                          });
                        },
                        child: Icon(
                          Icons.play_arrow,
                          size: 30,
                        ),
                      ),
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    child: Slider(
                        value: playbackValue,
                        max: double.parse(_vlcPlayerController!
                            .value.duration.inSeconds
                            .toString()),
                        onChanged: (value) {
                          setState(() {
                            _vlcPlayerController!
                                .seekTo(Duration(seconds: value.toInt()));
                          });

                          // setState(() {});
                        }),
                  ),
                ),
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
                    _isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                    size: 30,
                  ),
                )
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
