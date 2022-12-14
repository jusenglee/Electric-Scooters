import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'login_Page.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/app_controller.dart';

void main() {
  runApp(
      MaterialApp(
          home : MyApp()
      )
  );
}
class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
  //스테이트풀 위젯 설정
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {   //앱 실행시 우선수행
    // TODO: implement initState
    super.initState();
     final AppController c = Get.put(AppController());
     c.initialize();//초기화
  }


  @override   //메인 화면 코딩
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(   //상단바
          leading: IconButton(
            icon: Icon(Icons.login),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => login()), //로그인버튼
              );
            },
          ),
          actions: <Widget>[
            IconButton(onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QrView()) //QR 버튼
              );
              }, icon: Icon(Icons.camera),)
          ]),

        body: WebView(  //중앙화면(네이버 설정)
          initialUrl: 'https://www.naver.com/',
          javascriptMode: JavascriptMode.unrestricted,
      ),
         bottomNavigationBar: IconButton( //하단 아이콘바- 초기화 진행창으로 이동
            icon: Icon(Icons.add_box),
            onPressed: () {
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => initialize1())
              );
            }
        )
    );
  }
}
class initialize1 extends StatelessWidget {  //초기화 진행 클래스
  final AppController c = Get.put(AppController());
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
              return Center(
                  child: Obx(() => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(c.message.value?.notification?.title ?? 'title', style: TextStyle(fontSize: 20)),
                      Text(c.message.value?.notification?.body ?? 'message', style: TextStyle(fontSize: 15)),
                    ],
                  )));
            } else if (snapshot.hasError) {
              return Center(child: Text('failed to initialize'));
            } else {
              return Center(child: Text('initializing...'));
            }
          },
        ),
      ),
    );
  }
}




    class login extends StatelessWidget {  //로그인 클래스
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'login demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new LoginPage(),
    );
  }
}



class QrView extends StatefulWidget {   //qr코드 클래스1

  @override
  _QrViewState createState() => _QrViewState();
}



class _QrViewState extends State<QrView> {   //qr코드 클래스2
  var _qrString = "Empty Scan Code";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(),
          body: Column(
            children: [
              Text(_qrString),
              ElevatedButton(onPressed: () => _scan(), child: Icon(Icons.qr_code))
            ],
          ),
        ));
  }

  Future<bool> _getStatuses() async {  //qr코드 클래스 3
    Map<Permission, PermissionStatus> statuses =
    await [Permission.storage, Permission.camera].request();

    if (await Permission.camera.isGranted &&
        await Permission.storage.isGranted) {
      return Future.value(true);
    } else {
      return Future.value(false);
    }
  }

  Future _scan() async {   //qr코드 클래스 4
    await _getStatuses();
    String? qrString = await scanner.scan();
    if (qrString != null) {
      setState(() {
        _qrString = qrString;
      });
    }
  }
}