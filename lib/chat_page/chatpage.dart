import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kwentokape/chat_page/bloc/chat_bloc.dart';
import 'package:kwentokape/constants/constants.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();
    final TextEditingController _textEditingController =
        TextEditingController();
    BlocProvider.of<ChatBloc>(context).add(const CreateUser());
    return Scaffold(
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state.status == Status.looking) {
            return Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.brown[700],
                    ),
                    const Text("Looking for someone"),
                  ]),
            );
          } else if (state.status == Status.chatting) {
            WidgetsBinding.instance?.addPostFrameCallback((_) {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            });

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    child: Column(children: [
                      const Text(
                        "It's a match!",
                        style:
                            TextStyle(fontSize: 28, fontFamily: 'Monday-Rain'),
                      ),
                      Column(
                        children: List.generate(state.messages.length, (index) {
                          return Align(
                            alignment: state.messages[index].uuid == state.uuid
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                                decoration: BoxDecoration(
                                    color:
                                        state.messages[index].uuid == state.uuid
                                            ? Colors.brown
                                            : Colors.brown[200],
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(15))),
                                padding: const EdgeInsets.all(12),
                                margin: EdgeInsets.only(
                                    top: 4,
                                    bottom: 4,
                                    left:
                                        state.messages[index].uuid == state.uuid
                                            ? 50
                                            : 8,
                                    right:
                                        state.messages[index].uuid == state.uuid
                                            ? 8
                                            : 50),
                                child: Text(
                                  state.messages[index].message,
                                  softWrap: true,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color:
                                        state.messages[index].uuid == state.uuid
                                            ? Colors.white
                                            : Colors.black,
                                  ),
                                )),
                          );
                        }),
                      )
                    ]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 15),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: TextField(
                            controller: _textEditingController,
                            textInputAction: TextInputAction.done,
                            onSubmitted: (message) {
                              BlocProvider.of<ChatBloc>(context)
                                  .add(SendMessage(message: message));
                              _textEditingController.clear();
                            },
                            decoration: const InputDecoration(
                              hintText: 'Message',
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            BlocProvider.of<ChatBloc>(context).add(SendMessage(
                                message: _textEditingController.text));
                            _textEditingController.clear();
                          },
                          icon: const Icon(Icons.send))
                    ],
                  ),
                ),
              ],
            );
          } else if (state.status == Status.end) {
            return Container(
              color: Colors.red,
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
