import 'package:flutter/material.dart';
import 'package:kwentokape/constants/constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KwentoKape',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Center(
            child: Text(
              'Welcome to KwentoKape',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 45,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                introduction,
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontSize: 21,
                ),
              ),
            ),
          ),
          Center(
            child: SizedBox(
                width: 150,
                child: TextButton(
                  style: ButtonStyle(
                      overlayColor: MaterialStatePropertyAll(Colors.white30),
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.brown[700])),
                  onPressed: () {},
                  child: const Text(
                    "Continue",
                    style: TextStyle(color: Colors.white),
                  ),
                )),
          )
        ],
      ),
    );
  }
}
