import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  getIt.registerSingleton<AppModel>(AppModelImplementation(),
      signalsReady: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    getIt
        .isReady<AppModel>()
        .then((_) => getIt<AppModel>().addListener(update));
    super.initState();
  }

  @override
  void dispose() {
    getIt<AppModel>().removeListener(update);
    super.dispose();
  }

  void update() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                getIt<AppModel>().counter.toString(),
                style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            elevation: 0.0,
              child: const Text('add'),
              onPressed: getIt<AppModel>().incrementCounter),
          const SizedBox(width: 20,),
          FloatingActionButton(
            elevation: 0.0,
              child: const Text('sub'),
              onPressed: getIt<AppModel>().decrementCounter),
        ],
      )
    );
  }
}

abstract class AppModel extends ChangeNotifier {
  void incrementCounter();
  void decrementCounter();
  int get counter;
}

class AppModelImplementation extends AppModel {
  int _counter = 0;
  GetIt getIt = GetIt.instance;

  AppModelImplementation() {
    Future.delayed(Duration(seconds: 3))
        .then((value) => getIt.signalReady(this));
  }

  @override
  int get counter => _counter;

  @override
  void incrementCounter() {
    _counter++;
    notifyListeners();
  }

  @override
  void decrementCounter() {
    _counter--;
    notifyListeners();
  }
}
