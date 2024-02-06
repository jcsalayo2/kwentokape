import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kwentokape/chat_page/bloc/chat_bloc.dart';
import 'package:kwentokape/chat_page/chatpage.dart';
import 'package:kwentokape/constants/constants.dart';
import 'package:kwentokape/firebase_options.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ChatBloc(),
        ),
      ],
      child: MaterialApp(
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
      ),
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Center(
              child: Text(
                'Welcome to KwentoKape',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Monday-Rain',
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
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  return Wrap(
                    spacing: 8.0, // Adjust the spacing between items as needed
                    children: List.generate(state.interests.length, (index) {
                      return TextButton(
                        style: ButtonStyle(
                            overlayColor:
                                const MaterialStatePropertyAll(Colors.white30),
                            backgroundColor: index % 2 == 0
                                ? MaterialStatePropertyAll(Colors.brown[400])
                                : MaterialStatePropertyAll(Colors.brown[300])),
                        onPressed: () {
                          BlocProvider.of<ChatBloc>(context)
                              .add(RemoveInterest(index: index));
                        },
                        child: Text(
                          state.interests[index],
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      );
                    }),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: SizedBox(
                width: 25,
                child: TextField(
                  decoration: const InputDecoration(hintText: "Add Interest"),
                  textInputAction: TextInputAction.done,
                  onSubmitted: (interest) {
                    BlocProvider.of<ChatBloc>(context)
                        .add(AddInterest(interest: interest));
                  },
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: SizedBox(
                    width: 150,
                    child: TextButton(
                      style: ButtonStyle(
                          overlayColor:
                              const MaterialStatePropertyAll(Colors.white30),
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.brown[700])),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ChatPage()));
                      },
                      child: const Text(
                        "Continue",
                        style: TextStyle(color: Colors.white),
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
