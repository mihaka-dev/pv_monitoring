import 'package:flutter/material.dart';
import 'package:flutter_pv_monitoring/pv_data.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'PV Public Display Demo'),
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
  String? address = "Blank Address";
  String currentPower = "0 kW";
  bool isLogin = false;
  final storage = const FlutterSecureStorage();

  var api = PVData();

  void _loginVCOM() {
    api.loginVCOM();
    setState(() {
      isLogin = true;
      _getDetailSystem();
    });
  }

  void _getDetailSystem() {
    api.detailSystem().then((value) {
      setState(() {
        address = value.data?.address?.city;
      });
    });
    api.currentPower().then((value) {
      double val = value['value'] / 1000;

      setState(() {
        currentPower = '${val.toStringAsFixed(2)} kW';
      });
    });
  }

  @override
  void initState() {
    api.checkToken().then((result) {
      result ? debugPrint('Token valid') : debugPrint('Token Invalid');
      isLogin = result;
      if (!result) {
        _loginVCOM();
      }
      _getDetailSystem();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/BG_IMAGE.png'))),
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 4,
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.fromLTRB(0, 40, 0, 40),
              alignment: Alignment.topLeft,
              decoration:
                  const BoxDecoration(color: Color.fromARGB(150, 33, 33, 48)),
              child: Column(children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Current Power",
                        style: TextStyle(color: Colors.white, fontSize: 30)),
                    Text(currentPower,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 70)),
                  ],
                ),
                Expanded(child: Container()),
                Image.asset('assets/images/ALFA_LOGO.png')
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
