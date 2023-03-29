/*
approach #1
ListView(
        children: [
          Center(
            child: FilledButton(
                onPressed: (() {
                  storage.printListItems();
                }),
                child: const Text("print storage items")),
          ),
          Center(
            child: FilledButton(
                onPressed: (() async {
                  vidList = await storage.getAllVideos();
                  print(vidList);
                }),
                child: const Text("Get list of videos")),
          ),
          Container(color: Colors.purple,child: const TestVideoPlayerItem(),),
          const TestVideoPlayerItem(),
          const TestVideoPlayerItem(),
          const VideoItem(url:'https://firebasestorage.googleapis.com/v0/b/thrivebynightdev-866d3.appspot.com/o/bullygirlsmarch-8-1.mov?alt=media&token=800d7c37-f3c7-4018-9d9d-ce175e05fea6')

        ],
      ),

      */








/*
approach #2
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
    // TODO: implement initState
    super.initState();
    getVidURLs();
    getCloudVidURLs();
    print(cloudVideoList);
   
  }

  void getVidURLs() async {
    vidList = await storage.getAllVideos();
  }

  void getCloudVidURLs() async {
    cloudVideoList = await storage.getCloudVideos();
    setState(){}
  }

  Future<List<CloudVideo>> getCloudTest() async {
    List<CloudVideo> _a = await storage.getCloudVideos();
    return _a;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Thrivebynightdev")),
        body: ListView.builder(
            itemCount: cloudVideoList.length,
            itemBuilder: (context, index) {
              return VideoItem(
                  url: cloudVideoList[index].url,
                  title: cloudVideoList[index].name);
            }));
  }
}


*/