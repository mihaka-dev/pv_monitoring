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
    });
  }

  void _getDetailSystem() {
    api.detailSystem().then((value) {
      setState(() {
        address = value.data?.address?.city;
      });
    });
    api.currentPower().then((value) {
      setState(() {
        currentPower = '${value['value']} kW';
      });
    });
  }

  @override
  void initState() {
    api.checkToken().then((value) {
      value ? debugPrint('Token valid') : debugPrint('Token Invalid');
      setState(() {
        isLogin = value;
        _getDetailSystem();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              address ?? "",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Container(
              margin: const EdgeInsets.all(20),
              height: 200,
              width: 200,
              color: Colors.blueGrey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(currentPower,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 30)),
                      const Text("Current Output",
                          style: TextStyle(color: Colors.white))
                    ],
                  ),
                  const Text("Total Yield",
                      style: TextStyle(color: Colors.white)),
                  const Text("CO Avoidance",
                      style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            ElevatedButton(
                onPressed: _loginVCOM, child: const Text("Login VCOM")),
            ElevatedButton(
                onPressed: isLogin ? _getDetailSystem : null,
                child: const Text("Get Data"))
          ],
        ),
      ),
    );
  }
}
