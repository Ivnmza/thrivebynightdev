import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:video_player/video_player.dart';
import 'firebase_options.dart';
import 'service/storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Thrivebynightdev',
      theme: ThemeData(
        brightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final storage = StorageService();

  late var vidList = [];

  late var cloudVideoList = [];

  @override
  void initState() {
    super.initState();
    //getVidURLs();
    // getCloudVidURLs();
    print('cloudvideolist $cloudVideoList');
  }

  void getVidURLs() async {
    vidList = await storage.getAllVideos();
  }

  void getCloudVidURLs() async {
    cloudVideoList = await storage.getCloudVideos();
  }

  Future<List<CloudVideo>> getCloudTest() async {
    List<CloudVideo> _a = await storage.getCloudVideos();
    print('get cloud test: ${_a}');
    return _a;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Thrivebynightdev")),
        body: FutureBuilder(
          future: getCloudTest(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    return VideoItem(
                        url: snapshot.data![index].url,
                        title: snapshot.data![index].name);
                  },
                );
              }
            } else if (snapshot.hasError) {
              return Text('no data');
            }
            return CircularProgressIndicator();
          },
        ));
  }
}

class VideoItem extends StatefulWidget {
  const VideoItem({super.key, required this.url, required this.title});
  final String url;
  final String title;

  @override
  State<VideoItem> createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url);
    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(padding: const EdgeInsets.only(top: 20.0)),
        Text(widget.title),
        Container(
          padding: const EdgeInsets.all(20),
          child: AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                VideoPlayer(_controller),
                ClosedCaption(text: _controller.value.caption.text),
                _ControlsOverlay(controller: _controller),
                VideoProgressIndicator(_controller, allowScrubbing: true),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TestVideoPlayerItem extends StatefulWidget {
  const TestVideoPlayerItem({super.key});

  @override
  State<TestVideoPlayerItem> createState() => _TestVideoPlayerItemState();
}

class _TestVideoPlayerItemState extends State<TestVideoPlayerItem> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        'https://firebasestorage.googleapis.com/v0/b/thrivebynightdev-866d3.appspot.com/o/2023-03-22-21-11-18.mov?alt=media&token=42fcf4de-ccdf-4d32-89df-137789fd0428',
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),);
    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(padding: const EdgeInsets.only(top: 20.0)),
        const Text('With remote mp4'),
        Container(
          padding: const EdgeInsets.all(20),
          child: AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                VideoPlayer(_controller),
                ClosedCaption(text: _controller.value.caption.text),
                _ControlsOverlay(controller: _controller),
                VideoProgressIndicator(_controller, allowScrubbing: true),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({required this.controller});

  static const List<Duration> _exampleCaptionOffsets = <Duration>[
    Duration(seconds: -10),
    Duration(seconds: -3),
    Duration(seconds: -1, milliseconds: -500),
    Duration(milliseconds: -250),
    Duration.zero,
    Duration(milliseconds: 250),
    Duration(seconds: 1, milliseconds: 500),
    Duration(seconds: 3),
    Duration(seconds: 10),
  ];
  static const List<double> _examplePlaybackRates = <double>[
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? const SizedBox.shrink()
              : Container(
                  color: Colors.black26,
                  child: const Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 100.0,
                      semanticLabel: 'Play',
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
        Align(
          alignment: Alignment.topLeft,
          child: PopupMenuButton<Duration>(
            initialValue: controller.value.captionOffset,
            tooltip: 'Caption Offset',
            onSelected: (Duration delay) {
              controller.setCaptionOffset(delay);
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<Duration>>[
                for (final Duration offsetDuration in _exampleCaptionOffsets)
                  PopupMenuItem<Duration>(
                    value: offsetDuration,
                    child: Text('${offsetDuration.inMilliseconds}ms'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.captionOffset.inMilliseconds}ms'),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: PopupMenuButton<double>(
            initialValue: controller.value.playbackSpeed,
            tooltip: 'Playback speed',
            onSelected: (double speed) {
              controller.setPlaybackSpeed(speed);
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<double>>[
                for (final double speed in _examplePlaybackRates)
                  PopupMenuItem<double>(
                    value: speed,
                    child: Text('${speed}x'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.playbackSpeed}x'),
            ),
          ),
        ),
      ],
    );
  }
}


// 3/22/23
//23:12 - lets try just listAll()
//2:14 - actually lets just implement the video player first
//3/23/23
//08:00 - video is hardcoded but streaming/playing from storage bucket
// next is iterate all videos to list

// 3/23/23
// 10:31pm
// 3/24/23
// 7:26pm - first lets  refactor TestVideoPlayerItem to accept  the video url as a parameter
// 7:56 - What is  a logging Framework?
// 12:28am - create storage service method that returns a list in order to use a listview builder
// 2:08am - convert home page to stateful so storage service can call to get list of videos url
// 03:08am - create new storage service to map to new video data video model

// 03/26/23
//1:30am - Last issue i . was having was the list isnt being loaded initally, only after a hot restart does it  show up
// 1:44 - maybe using futurebuilder
// 7:13 pm - lets try a 1. futurebuilder or 2. the " isLoading method"
// 03.27
// 11:00 pm - loaded to mh phone. works as intended.
// 03:28
// ok awesome.   the thumbnails work, as i was getting  the  weird  "composite textures "  error previously.
// 03:38 - fix the  multiple videos playing  thing
// 4:00 - dont think it makes much a difference for right now.
// 4:03 - Want to  implement UI presentation widger for video. I could just use the info directly drom cloud storage query

//8:40pm
// updating firebase plugins
// looked into what firebase ios sdk version means https://firebase.google.com/support/release-notes/ios#10.5.0  https://github.com/firebase/firebase-ios-sdk/releases

// 9:45 pm
//updated firestore pubspec 4.4.5 from 4.4.4.
// updated firebase core to 2.8.0
// updated firebase storage 11.0.15 -> .16

// 11:02,
// it  all seems to have worked. ultimately using repo update Firebase/firestore downloaded the 10.6 ios sdk.
// there was some trouble for the xcode taking a couple of  restarts t o get  it right tho.