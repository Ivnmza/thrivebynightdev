/*
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