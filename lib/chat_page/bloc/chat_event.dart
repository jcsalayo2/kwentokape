part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class CreateUser extends ChatEvent {
  @override
  List<Object> get props => [];

  const CreateUser();
}

class ListenToUserInfo extends ChatEvent {
  @override
  List<Object> get props => [];

  const ListenToUserInfo();
}

class FindStranger extends ChatEvent {
  @override
  List<Object> get props => [];

  const FindStranger();
}

class FindRoom extends ChatEvent {
  @override
  List<Object> get props => [];

  const FindRoom();
}

class AddInterest extends ChatEvent {
  final String interest;
  @override
  List<Object> get props => [];

  const AddInterest({required this.interest});
}

class RemoveInterest extends ChatEvent {
  final int index;
  @override
  List<Object> get props => [];

  const RemoveInterest({required this.index});
}

class SendMessage extends ChatEvent {
  final String message;
  @override
  List<Object> get props => [];

  const SendMessage({required this.message});
}

class GetMessage extends ChatEvent {
  final MessageModel message;
  @override
  List<Object> get props => [];

  const GetMessage({required this.message});
}