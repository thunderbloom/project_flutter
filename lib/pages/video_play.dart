import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_flutter/views/home_screen.dart';
import 'package:video_player/video_player.dart';
import 'package:mysql1/mysql1.dart';
import 'package:project_flutter/pages/mysql.dart';
import 'package:project_flutter/pages/data_table.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class VideoPlay extends StatefulWidget {
  const VideoPlay({
    Key? key,
  }) : super(key: key);
  @override
  _VideoPlayState createState() => _VideoPlayState();
}

class _VideoPlayState extends State<VideoPlay> {
  //----------------------------------------

  String userinfo = '';

  void setData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userinfo = prefs.getString('id')!;
    });

    try {
      setState(() {
        final String? userinfo = prefs.getString('id');
      });
    } catch (e) {}
  }

  Future<List<Video>> getSQLData() async {
    final List<Video> videoList = [];
    final Mysql db = Mysql();
    await db.getConnection().then((conn) async {
      String sqlQuery =
          'select file_name from Video where user_id="$userinfo" order by file_name DESC';
      await conn.query(sqlQuery).then((result) {
        for (var res in result) {
          final videoModel = Video(
            // id: res["id"],
            file_name: res["file_name"],
            // Datetime: res["Datetime"],
          );
          videoList.add(videoModel);
        }
      }).onError((error, stackTrace) {
        print(error);
        return null;
      });
      conn.close();
    });
    return videoList;
  }

  //------------------------------------------------

  late VideoPlayerController controller;

  var urls = '';

  @override
  void initState() {
    loadVideoPlayer(urls);
    // loadVideoPlayer('http://34.64.233.244:9898/download/video2022-12-21_10-24-08-503542.mp4');
    super.initState();
    setData();
  }

  loadVideoPlayer(String urls) {
    controller = VideoPlayerController.network(urls);
    //'http://34.64.233.244:9898/download/${data[index].file_name.toString()}'
    //'http://34.64.233.244:9898/download/video2022-12-21_10-24-08-503542.mp4');
    // 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4');

    controller.addListener(() {
      setState(() {});
    });
    controller.initialize().then((urls) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("영상 확인"),
        backgroundColor: Color(0xff1160aa),
        actions: <Widget>[
          TextButton(
              child: Image.asset(
                // width: 50,
                // height: 35,
                'assets/icons/live.png',
                fit: BoxFit.fill,
              ),
              onPressed: () async {
                final url = Uri.parse(
                  'http://192.168.41.191:5000',
                );
                if (await canLaunchUrl(url)) {
                  launchUrl(url);
                } else {
                  // ignore: avoid_print
                  print("Can't launch $url");
                }
                print('live streaming clicked');
              })
          //CupertinoButton(
          //    color: Colors.white,
          //    //padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
          //    child: Image.asset(
          //      width: 50,
          //      height: 35,
          //      'assets/icons/live.png',
          //      fit: BoxFit.fill,
          //    ),
          //    //Text(
          //    //  'live',
          //    //  style: TextStyle(
          //    //    color: Colors.red,
          //    //    fontSize: 25,
          //    //    fontWeight: FontWeight.bold,
          //    //  ),
          //    //),
          // onPressed: () async {
          //   final url = Uri.parse(
          //     'http://192.168.41.191:5000',
          //   );
          //   if (await canLaunchUrl(url)) {
          //     launchUrl(url);
          //   } else {
          //     // ignore: avoid_print
          //     print("Can't launch $url");
          //   }
          //   print('live streaming clicked');
          // }
          //)
        ],
      ),
      body: Container(
          child: ListView(children: [
        AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: VideoPlayer(controller),
        ),
        Container(
          //duration of video
          child:
              Text("총 재생시간: " + controller.value.duration.toString()),
        ),
        Container(
            child: VideoProgressIndicator(controller,
                allowScrubbing: true,
                colors: VideoProgressColors(
                    backgroundColor: Colors.blueGrey,
                    bufferedColor: Colors.blueGrey,
                    playedColor: Colors.blueAccent))),
        Container(
          child: Row(
            children: [
              IconButton(
                  onPressed: () {
                    if (controller.value.isPlaying) {
                      controller.pause();
                    } else {
                      controller.play();
                    }

                    setState(() {});
                  },
                  icon: Icon(controller.value.isPlaying
                      ? Icons.pause
                      : Icons.play_arrow)),
              IconButton(
                  onPressed: () {
                    controller.seekTo(Duration(seconds: 0));

                    setState(() {});
                  },
                  icon: Icon(Icons.stop))
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          child: Text(
            '저장된 영상 내역',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
            child: SizedBox(
          child: getDBData(),
          height: 300,
        )),
      ])),
    );
  }

  //------------------------------------------------
  FutureBuilder<List> getDBData() {
    return FutureBuilder<List>(
        future: getSQLData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final data = snapshot.data as List;
              String urls =
                  'http://34.64.233.244:9898/download/${data[index].file_name.toString()}';

              return Card(
                  child: Container(
                      child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Text(
                      data[index].file_name.toString(),
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    selected: true,
                    onTap: () {
                      print(urls);
                      loadVideoPlayer(urls);
                    },
                  ),
                ],
              )));
            },
          );
        });
  }
  //---------------------------------------------
}
