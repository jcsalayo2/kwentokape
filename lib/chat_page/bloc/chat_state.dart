part of 'chat_bloc.dart';

class ChatState extends Equatable {
  final String uuid;
  final String roomId;
  final DateTime dateTime;
  final List<String> interests;
  final List<MessageModel> messages;
  final Status status;
  final StreamSubscription<DocumentSnapshot<Object?>>? userSubscription;
  final StreamSubscription<QuerySnapshot<Object?>>? roomSubscription;
  final StreamSubscription<QuerySnapshot<Object?>>? messageSubscription;

  @override
  List<Object?> get props => [
        uuid,
        roomId,
        dateTime,
        interests,
        messages,
        status,
        userSubscription,
        roomSubscription,
        messageSubscription,
      ];

  const ChatState({
    required this.roomId,
    required this.uuid,
    required this.dateTime,
    required this.interests,
    required this.messages,
    required this.status,
    required this.userSubscription,
    required this.roomSubscription,
    required this.messageSubscription,
  });

  ChatState.initial()
      : uuid = const Uuid().v8(),
        dateTime = DateTime.now(),
        interests = [],
        messages = [],
        status = Status.looking,
        userSubscription = null,
        roomSubscription = null,
        messageSubscription = null,
        roomId = '';

  ChatState copyWith({
    String? uuid,
    DateTime? dateTime,
    List<String>? interests,
    List<MessageModel>? messages,
    Status? status,
    StreamSubscription<DocumentSnapshot<Object?>>? userSubscription,
    StreamSubscription<QuerySnapshot<Object?>>? roomSubscription,
    StreamSubscription<QuerySnapshot<Object?>>? messageSubscription,
    String? roomId,
  }) {
    return ChatState(
      uuid: uuid ?? this.uuid,
      dateTime: dateTime ?? this.dateTime,
      interests: interests ?? this.interests,
      messages: messages ?? this.messages,
      status: status ?? this.status,
      userSubscription: userSubscription ?? this.userSubscription,
      roomSubscription: roomSubscription ?? this.roomSubscription,
      messageSubscription: messageSubscription ?? this.messageSubscription,
      roomId: roomId ?? this.roomId,
    );
  }
}
